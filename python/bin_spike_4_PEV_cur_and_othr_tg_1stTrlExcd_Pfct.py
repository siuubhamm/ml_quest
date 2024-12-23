import numpy as np
from scipy.stats import norm

def bin_spike_4_PEV_cur_and_othr_tg_1stTrlExcd_Pfct(t_spike, t_trig, TrialID, width, slide, Fx_ana_win, Go_ana_win, Fb_ana_win, numBx, Cycle, targnum, touchOrder):
    binspikes = []
    curr_targ_idx = []
    other_targ_idx = []

    w = 30  # Gaussian SD not used
    Gauss_width = max(11, 6 * w + 1)  # 
    kernel = norm.pdf(np.arange(-np.floor(Gauss_width / 2), np.floor(Gauss_width / 2) + 1), 0, w)

    COI = Cycle

    # Extract trial event data with Reveal event from raw data (trials appropriate for analyses)
    RevealTime = t_trig[1:, 5]
    ActiveTrial = np.array([0 if len(rt) == 0 or len(rt) != 1 else not np.isnan(rt) for rt in RevealTime])

    # Task specifics
    cellTask = TrialID[1:, 0]
    trialcounts = len(cellTask)
    cellTargnum = TrialID[1:, 2]
    cellChoicenum = TrialID[1:, 3]
    cellCyclenum = TrialID[1:, 4]
    cellTouchID = TrialID[1:, 7]
    celltcode = TrialID[1:, 5]

    for iii in range(len(celltcode)):
        if not celltcode[iii]:
            ActiveTrial[iii] = 0
            celltcode[iii] = np.nan

    TouchCountInCycle = []
    cellCorCount = np.full(trialcounts, np.nan)
    cellCorrectCount = 0
    TouchCountInCycle.append(1 if cellTouchID[0] == 1 else 0)

    lastCycle = 1
    for i in range(1, trialcounts):
        comp = lastCycle if np.isnan(cellCyclenum[i-1]) else cellCyclenum[i-1]
        if not np.isnan(cellCyclenum[i]):
            lastCycle = cellCyclenum[i]
        if cellCyclenum[i] == comp or np.isnan(cellCyclenum[i]):  # cycle continued
            TouchCountInCycle.append(TouchCountInCycle[i-1] + 1 if cellTouchID[i] else TouchCountInCycle[i-1])
            if cellTouchID[i] == 1:
                cellCorrectCount += 1
            cellCorCount[i] = cellCorrectCount
        else:  # new cycle
            TouchCountInCycle.append(1 if not np.isnan(celltcode[i]) else 0)
            cellCorrectCount = 0
            if cellTouchID[i] == 1:
                cellCorrectCount += 1
            cellCorCount[i] = cellCorrectCount

    celllevlatency = TrialID[1:, 9]
    celltouchlatency = TrialID[1:, 10]
    cellTargLoc = TrialID[1:, 1]

    cellOtherTarg = []
    nTrl2OtherTargTch = np.full(trialcounts, np.nan)

    for i_trl in range(len(cellTargLoc)):
        if cellTouchID[i_trl] == 1 and cellTargnum[i_trl] == 2:  # correct touch in 2-target condition
            currentTargs = np.array(cellTargLoc[i_trl])
            cellOtherTarg.append(currentTargs[currentTargs != celltcode[i_trl]])

            ntrl_to_check = []
            if cellCorCount[i_trl] == 1:  # first touch
                ntrl_to_check = len(celltcode[i_trl:]) - 1
                for i_check in range(ntrl_to_check):
                    if celltcode[i_trl + i_check] == cellOtherTarg[i_trl]:
                        nTrl2OtherTargTch[i_trl] = i_check
                        break
            elif cellCorCount[i_trl] == 2:
                ntrl_to_check = len(celltcode[:i_trl]) - 1
                for i_check in range(ntrl_to_check):
                    if celltcode[i_trl - i_check] == cellOtherTarg[i_trl]:
                        nTrl2OtherTargTch[i_trl] = i_check
                        break
        else:
            cellOtherTarg.append(np.nan)

    # Define sps for storing spike data
    sps = {'Fx_bin': [], 'Go_bin': [], 'Fb_bin': [], 'All_bin': []}

    trial_count = 0
    excld = 99

    trialnum = trialcounts

    for i in range(1, trialnum):
        if ActiveTrial[i] == 1 and \
            ((cellCyclenum[i] == 1 and TouchCountInCycle[i] > 1) or (cellCyclenum[i] > 1)) and \
            not np.isnan(np.where(cellCyclenum[i] == COI)) and \
            cellCorCount[i] == touchOrder and \
            cellTouchID[i] == 1 and \
            cellTask[i] == 1 and \
            cellChoicenum[i] == numBx and \
            cellTargnum[i] == targnum and \
            celltcode[i] != excld and \
            not np.isnan(t_trig[i+1, 5]) and \
            t_trig[i+1, 0] + Fx_ana_win[0] > 0 and \
            len(nTrl2OtherTargTch) >= i and \
            (cellCyclenum[i] >= 2 and nTrl2OtherTargTch[i] == 1 and TouchCountInCycle[i] == 1):

            trial_count += 1

            # Extracting fixation period activity in 'trial n'
            t_range = Fx_ana_win[1] - Fx_ana_win[0] + 1
            bn = int((t_range - width) / slide + 1)

            t_trig_data = t_trig[i + 1, 0]
            t_data0 = t_trig_data + Fx_ana_win[0]
            t_data1 = t_trig_data + Fx_ana_win[1]
            u_data = np.zeros(t_data1 - t_data0 + 1)
            u_data = t_spike[i][t_data0:t_data1]

            for j in range(bn):
                bs = slide * (j - 1) + 1
                be = bs + width - 1
                u_bin = np.zeros(width)
                u_bin = u_data[bs:be]
                sps['Fx_bin'].append(np.sum(u_bin == 1) / (width / 1000))

            # Extracting Go period activity in 'trial n'
            t_range = Go_ana_win[1] - Go_ana_win[0] + 1
            bn = int((t_range - width) / slide + 1)

            t_trig_data = t_trig[i + 1, 2]
            t_data0 = t_trig_data + Go_ana_win[0]
            t_data1 = t_trig_data + Go_ana_win[1]
            u_data = np.zeros(t_data1 - t_data0 + 1)
            u_data = t_spike[i][t_data0:t_data1]

            for j in range(bn):
                bs = slide * (j - 1) + 1
                be = bs + width - 1
                u_bin = np.zeros(width)
                u_bin = u_data[bs:be]
                sps['Go_bin'].append(np.sum(u_bin == 1) / (width / 1000))

            # Extracting Fb period activity in 'trial n'
            t_range = Fb_ana_win[1] - Fb_ana_win[0] + 1
            bn = int((t_range - width) / slide + 1)

            t_trig_data = t_trig[i + 1, 4]
            t_data0 = t_trig_data + Fb_ana_win[0]
            t_data1 = t_trig_data + Fb_ana_win[1]
            u_data = np.zeros(t_data1 - t_data0 + 1)
            u_data = t_spike[i][t_data0:t_data1]

            for j in range(bn):
                bs = slide * (j - 1) + 1
                be = bs + width - 1
                u_bin = np.zeros(width)
                u_bin = u_data[bs:be]
                sps['Fb_bin'].append(np.sum(u_bin == 1) / (width / 1000))

            # Identifying location of target (target idx)
            curr_targ_idx.append(celltcode[i])
            other_targ_idx.append(cellOtherTarg[i])

    # Creating unified spike data
    sps['All_bin'] = np.hstack([sps['Fx_bin'], sps['Go_bin'], sps['Fb_bin']])

    return binspikes, curr_targ_idx, other_targ_idx