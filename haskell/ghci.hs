
import GHC (runStmt, lookupName, runGhc,
            SingleStep(SingleStep), RunResult(RunOk))
import DynFlags (defaultDynFlags, dopt,
                 DynFlag(Opt_PrintExplicitForalls))
import PprTyThing (pprTyThing)
import Outputable (showSDoc)
-- import Outputable (printDump)
import MonadUtils (liftIO)

import GHC.Paths (libdir)
-- GHC.Paths is available via cabal install ghc-paths

main = do
  runGhc (Just libdir) $ do
    (RunOk names) <- runStmt "0" SingleStep
    (Just thing) <- lookupName (head names)
    let pefas = dopt Opt_PrintExplicitForalls defaultDynFlags
    -- liftIO $ printDump (pprTyThing pefas thing)
    liftIO $ putStrLn $ showSDoc (pprTyThing pefas thing)

{-
ghci: ghci: panic! (the 'impossible' happened)
  (GHC version 7.0.4 for i386-apple-darwin):
    no package state yet: call GHC.setSessionDynFlags

Please report this as a GHC bug:  http://www.haskell.org/ghc/reportabug
-}
