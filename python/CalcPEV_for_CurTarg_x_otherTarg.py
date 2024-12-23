import numpy as np
import scipy.io as sio

for i_run in range(1, 3):
    # Save i_run to file and load the relevant data
    np.save('i_run.npy', i_run)
    # Clear all variables (equivalent to `clear all` in MATLAB)
    del globals()['binned_data']
    del globals()['binned_labels']
    
    # Load the appropriate data file based on i_run
    if i_run == 1:
        data = sio.loadmat('Results_CurrVsOtherTarg_PEV_nonPerfectTrls_dv_pfc.mat')
    elif i_run == 2:
        data = sio.loadmat('Results_CurrVsOtherTarg_PEV_PerfectTrls_dv_pfc.mat')

    binned_data = data['binned_data']
    binned_labels = data['binned_labels']

    numCells = binned_data.shape[1]  # Number of cells

    PEV = []
    Pval = []
    
    fn = 'a'

    # Loop through the cells
    for i in range(numCells):
        print(i)
        
        SpRates_all = []
        Anova_matrix = []
        
        # Initialize empty lists for spikes
        spikes = {f"{x}_{y}": [] for x in range(1, 6) for y in range(1, 6) if x != y}
        
        # Get indices based on currentTarget_ID and otherTarget_ID
        for x in range(1, 6):
            for y in range(1, 6):
                if x != y:
                    idx = np.where((binned_labels['currentTarget_ID'][i] == x) & 
                                   (binned_labels['otherTarget_ID'][i] == y))[0]
                    spikes[f"{x}_{y}"] = binned_data[i][idx]

        # Concatenate spikes data
        for key, value in spikes.items():
            SpRates_all = np.vstack((SpRates_all, value)) if len(SpRates_all) > 0 else value
        
        # Initialize ANOVA matrix
        Anova_matrix = []
        
        # Add data for each condition
        for (x, y), spike_data in spikes.items():
            trs = len(spike_data)
            Anova_temp = np.zeros((trs, 2))
            Anova_temp[:, 0] = x
            Anova_temp[:, 1] = y
            Anova_matrix.extend(Anova_temp)

        Anova_matrix = np.vstack(Anova_matrix)
        
        # Now you can use SpRates_all and Anova_matrix for further analysis