# DynaSim mechanism files for simulating (McCarthy et al., 2008)

DynaSim-compatible mechanism files for simulation of the cortex of (McCarthy et
al., 2008).

Adding these mechanism files and associated functions into where you keep your
mechanism files for [DynaSim](https://github.com/DynaSim/DynaSim), e.g.
`/your/path/to/dynasim/models`, should enable you to simulate the computational
cortex from:

    McCarthy MM, Brown EN, Kopell N. Potential Network Mechanisms Mediating
    Electroencephalographic Beta Rhythm Changes during Propofol-Induced
    Paradoxical Excitation. J Neurosci. 2008;28: 13488–13504.
    doi:10.1523/JNEUROSCI.3536-08.2008 

This is NOT intended as a bit-perfect reproduction of the original model, but
rather just an open-source, adequate reproduction of the overall qualitative
results. This was originally ported by @jsherfey.

## Install and Usage

The easiest way to get started with this is:
1. Install DynaSim (https://github.com/DynaSim/DynaSim/wiki/Installation),
   including adding it to your MATLAB path.
2. Run `git clone https://github.com/asoplata/dynasim-mccarthy-2008-model` or
   download this code's repo
   (https://github.com/asoplata/dynasim-mccarthy-2008-model) into
   `'/your/path/to/dynasim/models'`, i.e. the `'models'` subdirectory of your
   copy of the DynaSim repo.
3. Start MATLAB, and run the main runscript `runMM08model.m`.

## References

1. McCarthy MM, Brown EN, Kopell N. Potential Network Mechanisms Mediating
   Electroencephalographic Beta Rhythm Changes during Propofol-Induced
   Paradoxical Excitation. J Neurosci. 2008;28: 13488–13504.
   doi:10.1523/JNEUROSCI.3536-08.2008
