{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Sobre where

import Reflex.Dom.Core
import qualified Data.Text as T
import Common.Api

sobre :: DomBuilder t m => m ()
sobre = do
    elAttr "div" ("class" =: "container sobre") $ do
        el "main" $ do
            el "h1" $ text $ "Sobre"
            el "p" $ text $ T.pack about
            elAttr "div" ("class" =: "alunos") $ do
                elAttr "div" ("class" =: "aluno") $ do
                    elAttr "img" ("src" =: "https://www.github.com/gabrielcavdias.png") blank
                    el "p" $ text $ T.pack helio
                    elAttr "a" ("href" =: "https://www.github.com/gabrielcavdias" <> "target" =: "_blank") $ text "Github >"
                elAttr "div" ("class" =: "aluno") $ do
                    elAttr "img" ("src" =: "https://www.github.com/Lucosan.png") blank
                    el "p" $ text $ T.pack lucca
                    elAttr "a" ("href" =: "https://www.github.com/Lucosan" <> "target" =: "_blank") $ text "Github >"