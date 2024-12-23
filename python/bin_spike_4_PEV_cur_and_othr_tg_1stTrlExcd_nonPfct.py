import numpy as np
from scipy.stats import norm

def bin_spike_4_PEV_cur_and_othr_tg_1stTrlExcd_nonPfct(t_spike, t_trig, TrialID, width, slide,
                                                     Fx_ana_win, Go_ana_win, Fb_ana_win, numBx,
                                                     Cycle, targnum, touchOrder):

    # Initialize variables
    binspikes = []
    curr_targ_idx = []
    other_targ_idx = []

    w = 30  # Gaussian SD
    Gauss_width = max(11, 6*w+1)  # should be an odd number
    kernel = norm.pdf(np.arange(-np.floor(Gauss_width/2), np.floor(Gauss_width/2) + 1), 0, w)

    COI = Cycle

    # Extract trial event data with Reveal event from raw data (trials appropriate for analyses)
    RevealTime = t_trig[1:, 5]
    ActiveTrial = np.array([0 if len(rt) != 1 or rt is None else 1 for rt in RevealTime])

    cellTask = TrialID[1:, 0]
    trialcounts = len(cellTask)
    cellTargnum = TrialID[1:, 2]
    cellChoicenum = TrialID[1:, 3]
    cellCyclenum = TrialID[1:, 4]
    cellTouchID = TrialID[1:, 7]

    celltcode = TrialID[1:, 5]
    for iii in range(len(celltcode)):
        if celltcode[iii] is None:
            ActiveTrial[iii] = 0
            celltcode[iii] = np.nan

    TouchCountInCycle = []
    if cellTouchID[0] == 1:
        cellCorCount = [1]
        cellCorrectCount = 1
        TouchCountInCycle.append(1)
    else:
        cellCorCount = [np.nan]
        cellCorrectCount = 0
        TouchCountInCycle.append(1)

    lastCycle = 1

    for i in range(1, trialcounts):
        comp = 0
        if np.isnan(cellCyclenum[i-1]):
            comp = lastCycle
        else:
            comp = cellCyclenum[i-1]
            if not np.isnan(cellCyclenum[i]):
                lastCycle = cellCyclenum[i]

        if cellCyclenum[i] == comp or np.isnan(cellCyclenum[i]):  # cycle continued
            if not np.isnan(celltcode[i]):
                TouchCountInCycle.append(TouchCountInCycle[i-1] + 1)
            else:
                TouchCountInCycle.append(TouchCountInCycle[i-1])

            if cellTouchID[i] == 1:
                cellCorrectCount += 1  # 1st or 2nd correct touch?
                cellCorCount.append(cellCorrectCount)
            else:
                cellCorCount.append(cellCorrectCount)
        else:  # new cycle
            if not np.isnan(celltcode[i]):
                TouchCountInCycle.append(1)
            else:
                TouchCountInCycle.append(0)

            cellCorrectCount = 0
            if cellTouchID[i] == 1:
                cellCorrectCount += 1
                cellCorCount.append(cellCorrectCount)
            else:
                cellCorCount.append(cellCorrectCount)

    # Lever release latency
    celllevlatency = TrialID[1:, 9]
    for iii in range(len(celllevlatency)):
        if celllevlatency[iii] is None:
            ActiveTrial[iii] = 0
            celllevlatency[iii] = np.nan

    # Lever-touch latency
    celltouchlatency = TrialID[1:, 10]
    for iii in range(len(celltouchlatency)):
        if celltouchlatency[iii] is None:
            ActiveTrial[iii] = 0
            celltouchlatency[iii] = np.nan

    # Target location
    cellTargLoc = TrialID[1:, 1]

    # Other target index (trial-by-trial)
    cellOtherTarg = [None] * len(cellTargLoc)
    nTrl2OtherTargTch = []

    for i_trl in range(len(cellTargLoc)):
        if cellTouchID[i_trl] == 1 and cellTargnum[i_trl] == 2:
            currentTargs = cellTargLoc[i_trl]
            cellOtherTarg[i_trl] = [targ for targ in currentTargs if targ != celltcode[i_trl]]

            ntrl_to_check = []
            if cellCorCount[i_trl] == 1:
                ntrl_to_check = len(celltcode[i_trl:]) - 1
                for i_check in range(ntrl_to_check):
                    if celltcode[i_trl + i_check] == cellOtherTarg[i_trl]:
                        nTrl2OtherTargTch.append(i_check)
                        break
            elif cellCorCount[i_trl] == 2:
                ntrl_to_check = len(celltcode[:i_trl]) - 1
                for i_check in range(ntrl_to_check):
                    if celltcode[i_trl - i_check] == cellOtherTarg[i_trl]:
                        nTrl2OtherTargTch.append(i_check)
                        break
        else:
            cellOtherTarg[i_trl] = np.nan

    trialnum = len(TrialID) - 1
    sps = {'Fx_bin': [], 'Go_bin': [], 'Fb_bin': [], 'All_bin': []}

    trial_count = 0
    excld = 99

    for i in range(1, trialnum):
        if ActiveTrial[i] == 1 and \
            ((cellCyclenum[i] == 1 and TouchCountInCycle[i] > 1) or cellCyclenum[i] > 1) and \
            np.isin(cellCyclenum[i], COI) and \
            cellCorCount[i] == touchOrder and \
            cellTouchID[i] == 1 and \
            cellTask[i] == 1 and \
            cellChoicenum[i] == numBx and \
            cellTargnum[i] == targnum and \
            celltcode[i] != excld and \
            not np.isnan(t_trig[i+1, 5]) and \
            t_trig[i+1, 0] + Fx_ana_win[0] > 0 and \
            len(nTrl2OtherTargTch) >= i and \
            ((cellCyclenum[i] == 1) or (cellCyclenum[i] >= 2 and (nTrl2OtherTargTch[i] > 1 or TouchCountInCycle[i] > 1))):

            trial_count += 1

            # Extracting fixation period activity
            t_range = Fx_ana_win[1] - Fx_ana_win[0] + 1
            bn = (t_range - width) // slide + 1  # number of sliding bins
            t_trig_data = t_trig[i+1, 0]
            t_data0 = t_trig_data + Fx_ana_win[0]
            t_data1 = t_trig_data + Fx_ana_win[1]
            u_data = t_spike[i][t_data0:t_data1]
            sps['Fx_bin'].append([np.sum(u_data[bs:be] == 1) / (width/1000) for bs, be in zip(range(0, len(u_data), slide), range(width, len(u_data), slide))])

            # Extracting Go period activity
            t_range = Go_ana_win[1] - Go_ana_win[0] + 1
            bn = (t_range - width) // slide + 1
            t_trig_data = t_trig[i+1, 2]
            t_data0 = t_trig_data + Go_ana_win[0]
            t_data1 = t_trig_data + Go_ana_win[1]
            u_data = t_spike[i][t_data0:t_data1]
            sps['Go_bin'].append([np.sum(u_data[bs:be] == 1) / (width/1000) for bs, be in zip(range(0, len(u_data), slide), range(width, len(u_data), slide))])

            # Extracting Fb period activity
            t_range = Fb_ana_win[1] - Fb_ana_win[0] + 1
            bn = (t_range - width) // slide + 1
            t_trig_data = t_trig[i+1, 4]
            t_data0 = t_trig_data + Fb_ana_win[0]
            t_data1 = t_trig_data + Fb_ana_win[1]
            u_data = t_spike[i][t_data0:t_data1]
            sps['Fb_bin'].append([np.sum(u_data[bs:be] == 1) / (width/1000) for bs, be in zip(range(0, len(u_data), slide), range(width, len(u_data), slide))])

            # Identifying location of target
            curr_targ_idx.append(celltcode[i])
            other_targ_idx.append(cellOtherTarg[i])

    # Creating unified spike data
    sps['All_bin'] = sps['Fx_bin'] + sps['Go_bin'] + sps['Fb_bin']

    return sps, curr_targ_idx, other_targ_idx