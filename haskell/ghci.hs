
import GHC (runStmt, lookupName, runGhc,
            SingleStep(SingleStep), RunResult(RunOk))
import DynFlags (defaultDynFlags, dopt,
                 DynFlag(Opt_PrintExplicitForalls))
import PprTyThing (pprTyThing)
import Outputable (printDump)
import MonadUtils (liftIO)

import GHC.Paths (libdir)
-- GHC.Paths is available via cabal install ghc-paths

main = do
  runGhc (Just libdir) $ do
    (RunOk names) <- runStmt "0" SingleStep
    (Just thing) <- lookupName (head names)
    let pefas = dopt Opt_PrintExplicitForalls defaultDynFlags
    liftIO $ printDump (pprTyThing pefas thing)
