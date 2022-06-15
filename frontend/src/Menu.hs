{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications, ScopedTypeVariables #-}

module Menu where

import Control.Monad.Fix
import qualified Data.Text as T
import Reflex.Dom.Core
import Home
import Formulario
import Tabela
import Sobre

data Pagina = Pagina1 | Pagina2 | Pagina3 | Pagina4

clickLi :: (DomBuilder t m) => Pagina -> T.Text -> m (Event t Pagina)
clickLi p t = do
    (ev, _) <- el' "li" (elAttr "a" ("href" =: "#") (text t))
    return $ (const p) <$> (domEvent Click ev)

header :: (DomBuilder t m, MonadHold t m) => m (Dynamic t Pagina)
header = do
    evs <- el "header" $ do

        el "div" $ do
              elAttr "img" ("src" =: "https://i.imgur.com/qnvwMj5.png") blank

        el "nav" $ do
          el "ul" $ do
            li1 <- clickLi Pagina1 "Home"
            li2 <- clickLi Pagina2 "Adicionar cartas à coleção"
            li3 <- clickLi Pagina3 "Minha coleção"
            li4 <- clickLi Pagina4 "Sobre"
            return (leftmost [li1, li2, li3, li4])

    holdDyn Pagina1 evs

currPag :: (DomBuilder t m, PostBuild t m, MonadHold t m, MonadFix m, Prerender js t m) => Pagina -> m ()
currPag p = do
    case p of
         Pagina1 -> home
         Pagina2 -> form
         Pagina3 -> table
         Pagina4 -> sobre

mainPag :: (DomBuilder t m, PostBuild t m, MonadHold t m, MonadFix m, Prerender js t m) => m ()
mainPag = do 
    pagina <- header
    dyn_ $ currPag <$> pagina 
