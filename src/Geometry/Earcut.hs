module Geometry.Earcut where

import qualified Data.Vector.Storable as S
import qualified Data.Vector as V
-- import Data.Vector.Storable (Vector)
import Foreign
import Foreign.C.Types
import System.IO.Unsafe

-- foreign import ccall tester :: IO Int
foreign import ccall "earcut"
  c_earcut :: Ptr Double -> Int -> Ptr (Ptr Word32) -> Ptr CULong -> IO ()

earcut :: [(Double, Double)] -> V.Vector (Int,Int,Int)
earcut p =
  let out = earcut' (S.fromList $ concat [ [x,y] | (x,y) <- p ])
  in V.generate (S.length out `div` 3) $ \i ->
    (fromIntegral $ out S.! (i*3+0)
    ,fromIntegral $ out S.! (i*3+1)
    ,fromIntegral $ out S.! (i*3+2))

earcut' :: S.Vector Double -> S.Vector Word32
earcut' polygon = unsafePerformIO $
  S.unsafeWith polygon $ \polyPtr ->
  alloca $ \outPtr ->
  alloca $ \outLen -> do
    c_earcut polyPtr (S.length polygon) outPtr outLen
    len <- peek outLen
    out <- newForeignPtr_ =<< peek outPtr
    return $ S.unsafeFromForeignPtr0 out (fromIntegral len)
