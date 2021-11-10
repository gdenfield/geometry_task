import glob
import h5py

h5_files = glob.glob('*.h5')
f = h5py.File(h5_files[0],'r')
ML = f['ML']