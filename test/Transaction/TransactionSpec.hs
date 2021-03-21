module Transaction.TransactionSpec (spec) where

import Test.Hspec

spec :: Spec
spec = do
  describe "Test 2" $ do
    it "Done" $ do
      "done" `shouldBe` "done"
