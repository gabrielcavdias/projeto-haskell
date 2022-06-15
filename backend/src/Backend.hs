{-# LANGUAGE LambdaCase, GADTs, OverloadedStrings, ScopedTypeVariables #-}

module Backend where

import Common.Route
import Obelisk.Backend
import Database.PostgreSQL.Simple
import Obelisk.Route
import Snap.Core
import Control.Monad.IO.Class (liftIO)
import qualified Data.Aeson as A
import Common.Api
import Data.Aeson.Text

getConn :: ConnectInfo
getConn = ConnectInfo "ec2-54-157-16-196.compute-1.amazonaws.com"
                      5432 -- porta
                      "fafkrfrbuydsqk"
                      "41f28dcf0743c63ce02ee92a35257fa734812c65b568a570d028412af2ca3f06"
                      "dbluj18q2lcaab"

migration :: Query
migration = "CREATE TABLE IF NOT EXISTS card (id SERIAL PRIMARY KEY, nome TEXT NOT NULL, cmc INTEGER NOT NULL, qtd INTEGER NOT NULL)"
 
backend :: Backend BackendRoute FrontendRoute
backend = Backend
   { _backend_run = \serve -> do
       dbcon <- connect getConn
       serve $ do
           \case 
                 BackendRoute_GetCards :/ () -> method GET $ do
                     res :: [Card] <- liftIO $ do
                         _ <- execute_ dbcon migration
                         query_ dbcon "SELECT * FROM card ORDER BY cmc DESC;" 
                     modifyResponse $ setResponseStatus 200 "OK"
                     writeLazyText (encodeToLazyText res)
                 BackendRoute_AddCard :/ () -> method POST $ do
                     card <- A.decode <$> readRequestBody 2000
                     case card of
                          Just card' -> do
                              _ <- liftIO $ do
                                  _ <- execute_ dbcon migration
                                  execute dbcon "INSERT INTO card (nome,cmc,qtd) VALUES (?,?,?)" 
                                          (cardNome card', cardCMC card', cardQtd card')
                              modifyResponse $ setResponseStatus 200 "OK"
                          Nothing -> modifyResponse $ setResponseStatus 500 "ERRO"
                 _ -> return ()
   , _backend_routeEncoder = fullRouteEncoder
   }
