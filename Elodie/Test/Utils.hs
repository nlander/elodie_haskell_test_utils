module Elodie.Test.Utils where

import qualified Test.Tasty as Test
import Test.Tasty (TestTree)
import qualified Test.Tasty.Runners as Runners
import qualified Test.Tasty.Options as Options

pattern :: String -> Maybe Options.OptionSet
pattern p = Options.singleOption <$> Runners.parseTestPattern p

runTest :: TestTree -> String -> IO ()
runTest tests p = do
  let mOptions = pattern p
  case mOptions of
    Nothing -> putStrLn "Parsing pattern failed"
    Just options -> do
      let mRun = Runners.tryIngredients Test.defaultIngredients options tests
      case mRun of 
        Nothing -> putStrLn "tryIngredients couldn't generate a runner"
        Just run -> do
          result <- run
          print result
