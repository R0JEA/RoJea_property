ObjectList = {}
local DecoMode = false
local MainCamera = nil
local curPos
local speeds = { 0.01, 0.05, 0.1, 0.2, 0.4, 0.5 }
local curSpeed = 1
local cursorEnabled = false
local SelectedObj = nil
local SelObjHash = {}
local SelObjPos = {}
local SelObjRot = {}
local SelObjId = 0
local isEdit = false
local rotateActive = false
local peanut = false
local previewObj = nil

-- CONFIG
Furniture = {
	['sofas'] = {
		label = 'Sofas',
		items = {
			[1] = { ['object'] = 'miss_rub_couch_01', ['price'] = 300, ['label'] = 'Old couch' },
			[2] = { ['object'] = 'prop_fib_3b_bench', ['price'] = 700, ['label'] = 'Threesits couch' },
			[3] = { ['object'] = 'prop_ld_farm_chair01', ['price'] = 250, ['label'] = 'Old chair' },
			[4] = { ['object'] = 'prop_ld_farm_couch01', ['price'] = 300, ['label'] = 'Old treesits couch' },
			[5] = { ['object'] = 'prop_ld_farm_couch02', ['price'] = 300, ['label'] = 'Old striped couch' },
			[6] = { ['object'] = 'v_res_d_armchair', ['price'] = 300, ['label'] = 'Old 1 Seat Couch Yellow' },
			[7] = { ['object'] = 'v_res_fh_sofa', ['price'] = 3700, ['label'] = 'corner sofa' },
			[8] = { ['object'] = 'v_res_mp_sofa', ['price'] = 3700, ['label'] = 'corner sofa 2' },
			[9] = { ['object'] = 'v_res_d_sofa', ['price'] = 700, ['label'] = 'couch 1' },
			[10] = { ['object'] = 'v_res_j_sofa', ['price'] = 700, ['label'] = 'Couch 2' },
			[11] = { ['object'] = 'v_res_mp_stripchair', ['price'] = 700, ['label'] = 'Couch 3' },
			[12] = { ['object'] = 'v_res_m_h_sofa_sml', ['price'] = 700, ['label'] = 'Couch 4' },
			[13] = { ['object'] = 'v_res_r_sofa', ['price'] = 700, ['label'] = 'Couch 5' },
			[14] = { ['object'] = 'v_res_tre_sofa', ['price'] = 700, ['label'] = 'Couch 6' },
			[15] = { ['object'] = 'v_res_tre_sofa_mess_a', ['price'] = 700, ['label'] = 'Couch 7' },
			[16] = { ['object'] = 'v_res_tre_sofa_mess_b', ['price'] = 700, ['label'] = 'Couch 8' },
			[17] = { ['object'] = 'v_res_tre_sofa_mess_c', ['price'] = 700, ['label'] = 'Couch 9' },
			[18] = { ['object'] = 'v_res_tt_sofa', ['price'] = 700, ['label'] = 'Couch 10' },
			[19] = { ['object'] = 'prop_rub_couch02', ['price'] = 700, ['label'] = 'Couch 11' },
			[20] = { ['object'] = 'v_ilev_m_sofa', ['price'] = 2000, ['label'] = 'White Couch' },
			[21] = { ['object'] = 'v_med_p_sofa', ['price'] = 1000, ['label'] = 'Lether Couch Brown' },
			[22] = { ['object'] = 'v_club_officesofa', ['price'] = 500, ['label'] = 'pauper Couch rood' },
			[23] = { ['object'] = 'bkr_prop_clubhouse_sofa_01a', ['price'] = 1000, ['label'] = 'Black Couch' },
			[24] = { ['object'] = 'apa_mp_h_stn_sofacorn_01', ['price'] = 5000, ['label'] = 'corner sofa 3' },
			[25] = { ['object'] = 'prop_couch_lg_02', ['price'] = 1000, ['label'] = 'Couch hout' },
			[26] = { ['object'] = 'apa_mp_h_stn_sofacorn_10', ['price'] = 5000, ['label'] = 'corner sofa 4' },
			[27] = { ['object'] = 'apa_mp_h_yacht_sofa_02', ['price'] = 1000, ['label'] = 'Brown Couch' },
			[28] = { ['object'] = 'apa_mp_h_yacht_sofa_01', ['price'] = 5000, ['label'] = 'White long Couch' },
			[29] = { ['object'] = 'prop_couch_01', ['price'] = 1000, ['label'] = 'sofa cushions' },
			[30] = { ['object'] = 'prop_couch_03', ['price'] = 1000, ['label'] = 'sofa yellow' },
			[31] = { ['object'] = 'prop_couch_04', ['price'] = 1000, ['label'] = 'leather sofa cushions' },
			[32] = { ['object'] = 'prop_couch_lg_05', ['price'] = 500, ['label'] = 'sofa corduroy' },
			[33] = { ['object'] = 'prop_couch_lg_06', ['price'] = 1000, ['label'] = 'leather sofa brown 2' },
			[34] = { ['object'] = 'prop_couch_lg_07', ['price'] = 1000, ['label'] = 'sofa cushions 2' },
			[35] = { ['object'] = 'prop_couch_lg_08', ['price'] = 1000, ['label'] = 'leather sofa brown 3' },
			[36] = { ['object'] = 'prop_couch_sm1_07', ['price'] = 500, ['label'] = 'leather sofa corner' },
			[37] = { ['object'] = 'prop_couch_sm2_07', ['price'] = 500, ['label'] = 'leather sofa straight' },
			[38] = { ['object'] = 'prop_couch_sm_06', ['price'] = 500, ['label'] = 'leather sofa small' },
			[39] = { ['object'] = 'apa_mp_h_stn_sofa2seat_02', ['price'] = 1000, ['label'] = 'love seat' },
			[40] = { ['object'] = 'apa_mp_h_stn_sofacorn_05', ['price'] = 5000, ['label'] = 'corner sofa 5' },
			[41] = { ['object'] = 'apa_mp_h_stn_sofacorn_06', ['price'] = 5000, ['label'] = 'corner sofa 6' },
			[42] = { ['object'] = 'apa_mp_h_stn_sofacorn_07', ['price'] = 5000, ['label'] = 'corner sofa 7' },
			[43] = { ['object'] = 'apa_mp_h_stn_sofacorn_08', ['price'] = 5000, ['label'] = 'corner sofa 8' },
			[44] = { ['object'] = 'apa_mp_h_stn_sofacorn_09', ['price'] = 5000, ['label'] = 'corner sofa 9' },
			[45] = { ['object'] = 'ex_mp_h_off_sofa_003', ['price'] = 1000, ['label'] = 'sofa blue fabric' },
			[46] = { ['object'] = 'ex_mp_h_off_sofa_01', ['price'] = 1000, ['label'] = 'sofa white leather' },
			[47] = { ['object'] = 'ex_mp_h_off_sofa_02', ['price'] = 1000, ['label'] = 'sofa black leather' },
			[48] = { ['object'] = 'hei_heist_stn_sofa2seat_03', ['price'] = 1000, ['label'] = 'sofa modern' },
			[49] = { ['object'] = 'hei_heist_stn_sofa2seat_06', ['price'] = 1000, ['label'] = 'couch brown' },
			[50] = { ['object'] = 'hei_heist_stn_sofa3seat_01', ['price'] = 1000, ['label'] = 'chaise lounge' },
			[51] = { ['object'] = 'hei_heist_stn_sofa3seat_02', ['price'] = 1000, ['label'] = 'sofa modern 2' },
			[52] = { ['object'] = 'hei_heist_stn_sofa3seat_06', ['price'] = 1000, ['label'] = 'sofa modern 3' },
			[53] = { ['object'] = 'imp_prop_impexp_sofabed_01a', ['price'] = 1000, ['label'] = 'sofa bed' },
			[54] = { ['object'] = 'prop_t_sofa_02', ['price'] = 1000, ['label'] = 'sofa bed2' }
		},
	},
	['chairs'] = {
		label = "Chair's",
		items = {
			[1] = { ['object'] = 'v_res_d_highchair', ['price'] = 700, ['label'] = 'High chair' },
			[2] = { ['object'] = 'apa_mp_h_stn_chairstrip_03', ['price'] = 500, ['label'] = 'Sitchair 4' },
			[3] = { ['object'] = 'v_res_fa_chair01', ['price'] = 700, ['label'] = 'Chairl' },
			[4] = { ['object'] = 'v_res_fa_chair02', ['price'] = 700, ['label'] = 'Chair 2' },
			[5] = { ['object'] = 'v_res_fh_barcchair', ['price'] = 700, ['label'] = 'High chair 2' },
			[6] = { ['object'] = 'v_res_fh_dineeamesa', ['price'] = 700, ['label'] = 'Kitchen chair 1' },
			[7] = { ['object'] = 'v_res_fh_dineeamesb', ['price'] = 700, ['label'] = 'Kitchen chair 2' },
			[8] = { ['object'] = 'v_res_fh_dineeamesc', ['price'] = 700, ['label'] = 'Kitchen chair 3' },
			[9] = { ['object'] = 'v_res_fh_easychair', ['price'] = 700, ['label'] = 'Chair 3' },
			[10] = { ['object'] = 'v_res_fh_kitnstool', ['price'] = 700, ['label'] = 'Chair 4' },
			[11] = { ['object'] = 'v_res_fh_singleseat', ['price'] = 700, ['label'] = 'High chair 3' },
			[12] = { ['object'] = 'v_res_jarmchair', ['price'] = 700, ['label'] = 'Arm Chair' },
			[13] = { ['object'] = 'v_res_j_dinechair', ['price'] = 700, ['label'] = 'Kitchen chair 4' },
			[14] = { ['object'] = 'v_res_j_stool', ['price'] = 700, ['label'] = 'Chair 5' },
			[15] = { ['object'] = 'v_res_mbchair', ['price'] = 700, ['label'] = 'MB Chair' },
			[16] = { ['object'] = 'v_res_m_armchair', ['price'] = 700, ['label'] = 'Arm Chair 2' },
			[17] = { ['object'] = 'v_res_m_dinechair', ['price'] = 700, ['label'] = 'Kitchen chair 5' },
			[18] = { ['object'] = 'v_res_study_chair', ['price'] = 700, ['label'] = 'Study Chair' },
			[19] = { ['object'] = 'v_res_trev_framechair', ['price'] = 700, ['label'] = 'Chair frame' },
			[20] = { ['object'] = 'v_res_tre_chair', ['price'] = 700, ['label'] = 'Chair 5' },
			[21] = { ['object'] = 'v_res_tre_officechair', ['price'] = 700, ['label'] = 'officeChair' },
			[22] = { ['object'] = 'v_res_tre_stool', ['price'] = 700, ['label'] = 'Chair 6' },
			[23] = { ['object'] = 'v_res_tre_stool_leather', ['price'] = 700, ['label'] = 'Lether Chair' },
			[24] = { ['object'] = 'v_res_tre_stool_scuz', ['price'] = 700, ['label'] = 'Chair Scuz' },
			[25] = { ['object'] = 'v_med_p_deskchair', ['price'] = 700, ['label'] = 'DeskChair' },
			[26] = { ['object'] = 'v_med_p_easychair', ['price'] = 700, ['label'] = 'Easy Chair' },
			[27] = { ['object'] = 'v_med_whickerchair1', ['price'] = 700, ['label'] = 'Whicker Chair' },
			[28] = { ['object'] = 'prop_direct_chair_01', ['price'] = 700, ['label'] = 'Direct Chair' },
			[29] = { ['object'] = 'prop_direct_chair_02', ['price'] = 700, ['label'] = 'Direct Chair 2' },
			[30] = { ['object'] = 'prop_yacht_lounger', ['price'] = 700, ['label'] = 'Yacht Chair 1' },
			[31] = { ['object'] = 'prop_yacht_seat_01', ['price'] = 700, ['label'] = 'Yacht Chair 2' },
			[32] = { ['object'] = 'prop_yacht_seat_02', ['price'] = 700, ['label'] = 'Yacht Chair 3' },
			[33] = { ['object'] = 'prop_yacht_seat_03', ['price'] = 700, ['label'] = 'Yacht Chair 4' },
			[34] = { ['object'] = 'v_ret_chair_white', ['price'] = 100, ['label'] = 'White Chair' },
			[35] = { ['object'] = 'v_ret_chair', ['price'] = 100, ['label'] = 'Chair 7' },
			[36] = { ['object'] = 'v_ret_ta_stool', ['price'] = 100, ['label'] = 'TA Chair' },
			[37] = { ['object'] = 'prop_cs_office_chair', ['price'] = 100, ['label'] = 'office Chair 2' },
			[38] = { ['object'] = 'apa_mp_h_yacht_armchair_01', ['price'] = 1000, ['label'] = 'White fauteuil' },
			[39] = { ['object'] = 'v_club_barchair', ['price'] = 300, ['label'] = 'Chair 8' },
			[40] = { ['object'] = 'prop_off_chair_04', ['price'] = 300, ['label'] = 'Desk Chair 2' },
			[41] = { ['object'] = 'v_club_stagechair', ['price'] = 500, ['label'] = 'fauteuil roze' },
			[42] = { ['object'] = 'v_club_officechair', ['price'] = 500, ['label'] = 'Desk Chair 3' },
			[43] = { ['object'] = 'prop_armchair_01', ['price'] = 500, ['label'] = 'Sit chair' },
			[44] = { ['object'] = 'prop_bar_stool_01', ['price'] = 300, ['label'] = 'Barstool' },
			[45] = { ['object'] = 'apa_mp_h_yacht_stool_01', ['price'] = 300, ['label'] = 'White pouffe' },
			[46] = { ['object'] = 'apa_mp_h_stn_chairarm_12', ['price'] = 500, ['label'] = 'Sitchair 3' },
			[47] = { ['object'] = 'apa_mp_h_stn_chairstool_12', ['price'] = 300, ['label'] = 'Feet support' },
			[48] = { ['object'] = 'prop_chair_03', ['price'] = 100, ['label'] = 'Wooden Chair' },
			[49] = { ['object'] = 'prop_couch_sm_05', ['price'] = 500, ['label'] = 'corduroy armchair' },
			[50] = { ['object'] = 'prop_couch_sm_07', ['price'] = 300, ['label'] = 'white armchair 2' },
			[51] = { ['object'] = 'prop_couch_sm_02', ['price'] = 300, ['label'] = 'orange armchair' },
			[52] = { ['object'] = 'apa_mp_h_stn_sofa_daybed_01', ['price'] = 500, ['label'] = 'lounge chair' },
			[53] = { ['object'] = 'apa_mp_h_stn_sofa_daybed_02', ['price'] = 500, ['label'] = 'lounge chair 2' },
			[54] = { ['object'] = 'apa_mp_h_din_chair_04', ['price'] = 500, ['label'] = 'modern chair' },
			[55] = { ['object'] = 'apa_mp_h_din_chair_08', ['price'] = 500, ['label'] = 'modern chair 2' },
			[56] = { ['object'] = 'apa_mp_h_din_chair_09', ['price'] = 500, ['label'] = 'modern chair 3' },
			[57] = { ['object'] = 'apa_mp_h_din_chair_12', ['price'] = 500, ['label'] = 'modern chair 4' },
			[58] = { ['object'] = 'apa_mp_h_din_stool_04', ['price'] = 500, ['label'] = 'modern chair 5' },
			[59] = { ['object'] = 'apa_mp_h_stn_chairarm_01', ['price'] = 500, ['label'] = 'modern chair 6' },
			[60] = { ['object'] = 'apa_mp_h_stn_chairarm_02', ['price'] = 500, ['label'] = 'modern chair 7' },
			[61] = { ['object'] = 'apa_mp_h_stn_chairarm_03', ['price'] = 500, ['label'] = 'modern chair 8' },
			[62] = { ['object'] = 'apa_mp_h_stn_chairarm_09', ['price'] = 500, ['label'] = 'modern chair 9' },
			[63] = { ['object'] = 'apa_mp_h_stn_chairarm_11', ['price'] = 500, ['label'] = 'modern chair 10' },
			[64] = { ['object'] = 'apa_mp_h_stn_chairarm_13', ['price'] = 500, ['label'] = 'modern chair 11' },
			[65] = { ['object'] = 'apa_mp_h_stn_chairarm_24', ['price'] = 500, ['label'] = 'modern chair 12' },
			[66] = { ['object'] = 'apa_mp_h_stn_chairarm_25', ['price'] = 500, ['label'] = 'modern chair 13' },
			[67] = { ['object'] = 'apa_mp_h_stn_chairarm_26', ['price'] = 500, ['label'] = 'modern chair 14' },
			[68] = { ['object'] = 'apa_mp_h_stn_chairstrip_04', ['price'] = 500, ['label'] = 'modern chair 15' },
			[69] = { ['object'] = 'apa_mp_h_stn_chairstrip_05', ['price'] = 500, ['label'] = 'modern chair 16' },
			[70] = { ['object'] = 'apa_mp_h_stn_chairstrip_08', ['price'] = 500, ['label'] = 'modern chair 17' },
			[71] = { ['object'] = 'apa_mp_h_stn_foot_stool_01', ['price'] = 500, ['label'] = 'pouffe' },
			[72] = { ['object'] = 'apa_mp_h_stn_foot_stool_02', ['price'] = 500, ['label'] = 'pouffe 2' },
			[73] = { ['object'] = 'apa_mp_h_yacht_barstool_01', ['price'] = 500, ['label'] = 'barstool 2' },
			[74] = { ['object'] = 'ba_prop_int_glam_stool', ['price'] = 500, ['label'] = 'barstool 3' },
			[75] = { ['object'] = 'ba_prop_battle_club_chair_01', ['price'] = 500, ['label'] = 'office chair' },
			[76] = { ['object'] = 'ba_prop_battle_club_chair_02', ['price'] = 500, ['label'] = 'office chair 2' },
			[77] = { ['object'] = 'ba_prop_battle_club_chair_03', ['price'] = 500, ['label'] = 'office chair 3' },
			[78] = { ['object'] = 'ba_prop_battle_control_seat', ['price'] = 500, ['label'] = 'gaming chair' }
		},
	},
	['beds'] = {
		label = 'Beds',
		items = {
			[1] = { ['object'] = 'v_res_d_bed', ['price'] = 700, ['label'] = 'Bed 1' },
			[2] = { ['object'] = 'v_res_lestersbed', ['price'] = 700, ['label'] = 'Bed 2' },
			[3] = { ['object'] = 'v_res_mbbed', ['price'] = 700, ['label'] = 'MB Bed' },
			[4] = { ['object'] = 'v_res_mdbed', ['price'] = 700, ['label'] = 'MD Bed' },
			[5] = { ['object'] = 'v_res_msonbed', ['price'] = 700, ['label'] = 'Bed 3' },
			[6] = { ['object'] = 'v_res_tre_bed1', ['price'] = 700, ['label'] = 'Bed 4' },
			[7] = { ['object'] = 'v_res_tre_bed2', ['price'] = 700, ['label'] = 'T Bed' },
			[8] = { ['object'] = 'v_res_tt_bed', ['price'] = 700, ['label'] = 'TT Bed' },
			[9] = { ['object'] = 'apa_mp_h_bed_with_table_02', ['price'] = 5000, ['label'] = 'fancy bed' },
			[10] = { ['object'] = 'apa_mp_h_bed_wide_05', ['price'] = 5000, ['label'] = 'red bed' },
			[11] = { ['object'] = 'apa_mp_h_bed_double_08', ['price'] = 3000, ['label'] = 'square bed' },
			[12] = { ['object'] = 'apa_mp_h_bed_double_09', ['price'] = 3000, ['label'] = 'modern bed' },
			[13] = { ['object'] = 'apa_mp_h_yacht_bed_01', ['price'] = 5000, ['label'] = 'california king' },
			[14] = { ['object'] = 'apa_mp_h_yacht_bed_02', ['price'] = 5000, ['label'] = 'california king 2' },
			[15] = { ['object'] = 'bkr_prop_biker_campbed_01', ['price'] = 100, ['label'] = 'camp bed' },
			[16] = { ['object'] = 'ex_prop_exec_bed_01', ['price'] = 700, ['label'] = 'small bed' },
			[17] = { ['object'] = 'gr_prop_bunker_bed_01', ['price'] = 700, ['label'] = 'klein bed 2' },
			[18] = { ['object'] = 'p_mbbed_s', ['price'] = 700, ['label'] = 'Bed 5' }
		},
	},
	['general'] = {
		label = 'General',
		items = {
			[1] = { ['object'] = 'v_corp_facebeanbag', ['price'] = 100, ['label'] = 'Bean Bag 1' },
			[2] = { ['object'] = 'v_res_cherubvase', ['price'] = 2500, ['label'] = 'White Vase' },
			[3] = { ['object'] = 'v_res_d_paddedwall', ['price'] = 300, ['label'] = 'Padded Wall' },
			[4] = { ['object'] = 'v_res_d_ramskull', ['price'] = 300, ['label'] = 'Item' },
			[5] = { ['object'] = 'v_res_d_whips', ['price'] = 300, ['label'] = 'Whips' },
			[6] = { ['object'] = 'v_res_fashmag1', ['price'] = 300, ['label'] = 'Mags' },
			[7] = { ['object'] = 'v_res_fashmagopen', ['price'] = 300, ['label'] = 'Mags Open' },
			[8] = { ['object'] = 'v_res_fa_magtidy', ['price'] = 300, ['label'] = 'Mag Tidy' },
			[9] = { ['object'] = 'v_res_fa_yogamat002', ['price'] = 300, ['label'] = 'Yoga Mat 1' },
			[10] = { ['object'] = 'v_res_fa_yogamat1', ['price'] = 300, ['label'] = 'Yoga Mat 2' },
			[11] = { ['object'] = 'v_res_fh_aftershavebox', ['price'] = 300, ['label'] = 'Aftershave' },
			[12] = { ['object'] = 'v_res_fh_flowersa', ['price'] = 300, ['label'] = 'Flowers' },
			[13] = { ['object'] = 'v_res_fh_fruitbowl', ['price'] = 300, ['label'] = 'Fruitbowl' },
			[14] = { ['object'] = 'v_res_fh_laundrybasket', ['price'] = 300, ['label'] = 'Laundry Basket' },
			[15] = { ['object'] = 'v_res_fh_pouf', ['price'] = 300, ['label'] = 'Pouf' },
			[16] = { ['object'] = 'v_res_fh_sculptmod', ['price'] = 300, ['label'] = 'Sculpture' },
			[17] = { ['object'] = 'v_res_j_magrack', ['price'] = 300, ['label'] = 'Mag Rack' },
			[18] = { ['object'] = 'v_res_jewelbox', ['price'] = 300, ['label'] = 'Jewel Box' },
			[19] = { ['object'] = 'v_res_mbbin', ['price'] = 300, ['label'] = 'Bin' },
			[20] = { ['object'] = 'v_res_mbowlornate', ['price'] = 300, ['label'] = 'Ornate Bowl' },
			[21] = { ['object'] = 'v_res_mbronzvase', ['price'] = 300, ['label'] = 'Bronze Vase' },
			[22] = { ['object'] = 'v_res_mchalkbrd', ['price'] = 300, ['label'] = 'Chalk Board' },
			[23] = { ['object'] = 'v_res_mddresser', ['price'] = 300, ['label'] = 'Dresser' },
			[24] = { ['object'] = 'v_res_mplinth', ['price'] = 300, ['label'] = 'Linth' },
			[25] = { ['object'] = 'v_res_mp_ashtrayb', ['price'] = 300, ['label'] = 'Ashtray' },
			[26] = { ['object'] = 'v_res_m_candle', ['price'] = 300, ['label'] = 'Candle' },
			[27] = { ['object'] = 'v_res_m_candlelrg', ['price'] = 300, ['label'] = 'Candle Large' },
			[28] = { ['object'] = 'v_res_m_kscales', ['price'] = 300, ['label'] = 'Scales' },
			[29] = { ['object'] = 'v_res_tt_bedpillow', ['price'] = 300, ['label'] = 'Bed Pillow' },
			[30] = { ['object'] = 'v_med_cor_whiteboard', ['price'] = 300, ['label'] = 'whiteboard' },
			[31] = { ['object'] = 'prop_ashtray_01', ['price'] = 100, ['label'] = 'asbak black' },
			[32] = { ['object'] = 'v_ret_fh_ashtray', ['price'] = 100, ['label'] = 'asbak stone' },
			[33] = { ['object'] = 'v_24_wdr_mesh_rugs', ['price'] = 500, ['label'] = 'Rag' },
			[34] = { ['object'] = 'apa_mp_h_acc_rugwooll_04', ['price'] = 500, ['label'] = 'Rug 2' },
			[35] = { ['object'] = 'ex_mp_h_acc_rugwoolm_04', ['price'] = 500, ['label'] = 'Rug 3' },
			[36] = { ['object'] = 'apa_mp_h_acc_rugwoolm_03', ['price'] = 500, ['label'] = 'Rug 4' },
			[37] = { ['object'] = 'apa_mp_h_acc_rugwooll_03', ['price'] = 500, ['label'] = 'Rug 5' },
			[38] = { ['object'] = 'apa_mp_h_acc_rugwoolm_04', ['price'] = 500, ['label'] = 'Rug 6' },
			[39] = { ['object'] = 'v_club_rack', ['price'] = 500, ['label'] = 'kledingrek' }
		},
	},
	['general2'] = {
		label = 'Props',
		items = {
			[1] = { ['object'] = 'prop_a4_pile_01', ['price'] = 100, ['label'] = 'A4 Pile' },
			[2] = { ['object'] = 'prop_amb_40oz_03', ['price'] = 100, ['label'] = '40 oz' },
			[3] = { ['object'] = 'prop_amb_beer_bottle', ['price'] = 100, ['label'] = 'Beer' },
			[4] = { ['object'] = 'prop_aviators_01', ['price'] = 100, ['label'] = 'Aviators' },
			[5] = { ['object'] = 'prop_barry_table_detail', ['price'] = 100, ['label'] = 'Detail' },
			[6] = { ['object'] = 'prop_beer_box_01', ['price'] = 100, ['label'] = 'Beers' },
			[7] = { ['object'] = 'prop_binoc_01', ['price'] = 100, ['label'] = 'Binoculars' },
			[8] = { ['object'] = 'prop_blox_spray', ['price'] = 100, ['label'] = 'Blox Spray' },
			[9] = { ['object'] = 'prop_bongos_01', ['price'] = 100, ['label'] = 'Bongos' },
			[10] = { ['object'] = 'prop_bong_01', ['price'] = 100, ['label'] = 'Bong' },
			[11] = { ['object'] = 'prop_boombox_01', ['price'] = 100, ['label'] = 'Boombox' },
			[12] = { ['object'] = 'prop_bowl_crisps', ['price'] = 100, ['label'] = 'Bowl Crisps' },
			[13] = { ['object'] = 'prop_candy_pqs', ['price'] = 100, ['label'] = 'Candy' },
			[14] = { ['object'] = 'prop_carrier_bag_01', ['price'] = 100, ['label'] = 'Carrier bag' },
			[15] = { ['object'] = 'prop_ceramic_jug_01', ['price'] = 100, ['label'] = 'Ceramic Jug' },
			[16] = { ['object'] = 'prop_cigar_pack_01', ['price'] = 100, ['label'] = 'Cigar Pack 1' },
			[17] = { ['object'] = 'prop_cigar_pack_02', ['price'] = 100, ['label'] = 'Cigar Pack 2' },
			[18] = { ['object'] = 'prop_cs_beer_box', ['price'] = 100, ['label'] = 'Beer Box 2' },
			[19] = { ['object'] = 'prop_cs_binder_01', ['price'] = 100, ['label'] = 'Binder' },
			[20] = { ['object'] = 'prop_cs_bs_cup', ['price'] = 100, ['label'] = 'Cup' },
			[21] = { ['object'] = 'prop_cs_cashenvelope', ['price'] = 100, ['label'] = 'Envelope' },
			[22] = { ['object'] = 'prop_cs_champ_flute', ['price'] = 100, ['label'] = 'Flute' },
			[23] = { ['object'] = 'prop_cs_duffel_01', ['price'] = 100, ['label'] = 'Duffel Bag' },
			[24] = { ['object'] = 'prop_cs_dvd', ['price'] = 50, ['label'] = 'DVD' },
			[25] = { ['object'] = 'prop_cs_dvd_case', ['price'] = 50, ['label'] = 'DVD Case' },
			[26] = { ['object'] = 'prop_cs_film_reel_01', ['price'] = 100, ['label'] = 'Film Reel' },
			[27] = { ['object'] = 'prop_cs_ilev_blind_01', ['price'] = 100, ['label'] = 'Blind' },
			[28] = { ['object'] = 'p_ld_bs_bag_01', ['price'] = 100, ['label'] = 'Bag' },
			[29] = { ['object'] = 'prop_cs_ironing_board', ['price'] = 100, ['label'] = 'Ironing Board' },
			[30] = { ['object'] = 'prop_cs_katana_01', ['price'] = 100, ['label'] = 'Katana' },
			[31] = { ['object'] = 'prop_cs_kettle_01', ['price'] = 100, ['label'] = 'Kettle' },
			[32] = { ['object'] = 'prop_cs_lester_crate', ['price'] = 100, ['label'] = 'Crate' },
			[33] = { ['object'] = 'prop_cs_petrol_can', ['price'] = 100, ['label'] = 'Petrol Can' },
			[34] = { ['object'] = 'prop_cs_sack_01', ['price'] = 100, ['label'] = 'Sack' },
			[35] = { ['object'] = 'prop_cs_script_bottle_01', ['price'] = 100, ['label'] = 'Script Bottle' },
			[36] = { ['object'] = 'prop_cs_script_bottle', ['price'] = 100, ['label'] = 'Script Bottle 2' },
			[37] = { ['object'] = 'prop_cs_street_binbag_01', ['price'] = 100, ['label'] = 'Bin Bag' },
			[38] = { ['object'] = 'prop_cs_whiskey_bottle', ['price'] = 100, ['label'] = 'Whiskey Bottle' },
			[39] = { ['object'] = 'prop_sh_bong_01', ['price'] = 100, ['label'] = 'Bong' },
			[40] = { ['object'] = 'prop_peanut_bowl_01', ['price'] = 100, ['label'] = 'Peanuts' },
			[41] = { ['object'] = 'prop_tumbler_01', ['price'] = 100, ['label'] = 'Tumbler' },
			[42] = { ['object'] = 'prop_weed_bottle', ['price'] = 100, ['label'] = 'Weed koker' },
			[43] = { ['object'] = 'p_cs_lighter_01', ['price'] = 100, ['label'] = 'Lighter' },
			[44] = { ['object'] = 'p_cs_papers_01', ['price'] = 100, ['label'] = 'Rolling papers' },
			[45] = { ['object'] = 'v_res_d_dildo_f', ['price'] = 100, ['label'] = 'dildo Black' },
			[46] = { ['object'] = 'v_res_d_dildo_c', ['price'] = 100, ['label'] = 'dildo white' },
			[47] = { ['object'] = 'v_res_d_dildo_a', ['price'] = 100, ['label'] = "Mommy's toy" },
			[48] = { ['object'] = 'prop_champ_cool', ['price'] = 100, ['label'] = 'Champagne cooler' },
			[49] = { ['object'] = 'prop_champ_01b', ['price'] = 100, ['label'] = 'champagnebottle' },
			[50] = { ['object'] = 'prop_champ_flute', ['price'] = 100, ['label'] = 'champagneglas' },
			[51] = { ['object'] = 'ba_prop_club_champset', ['price'] = 300, ['label'] = 'champagneset' },
			[52] = { ['object'] = 'v_res_fa_candle01', ['price'] = 100, ['label'] = 'candle blue' },
			[53] = { ['object'] = 'v_res_fa_candle02', ['price'] = 100, ['label'] = 'candle red' },
			[54] = { ['object'] = 'v_res_fa_candle03', ['price'] = 100, ['label'] = 'candle black' },
			[55] = { ['object'] = 'v_res_fa_candle04', ['price'] = 100, ['label'] = 'candle small' },
			[56] = { ['object'] = 'v_med_bottles2', ['price'] = 100, ['label'] = 'Chemicals' },
			[57] = { ['object'] = 'v_res_desktidy', ['price'] = 100, ['label'] = 'Office stuf' },
			[58] = { ['object'] = 'v_med_p_notebook', ['price'] = 100, ['label'] = "Note's" },
			[59] = { ['object'] = 'bkr_prop_weed_dry_01a', ['price'] = 100, ['label'] = 'mountain of weed' },
			[60] = { ['object'] = 'ba_prop_battle_trophy_battler', ['price'] = 100, ['label'] = 'fist trofee' },
			[61] = { ['object'] = 'ba_prop_battle_trophy_no1', ['price'] = 100, ['label'] = 'ster trofee' },
			[62] = { ['object'] = 'prop_golf_bag_01c', ['price'] = 100, ['label'] = 'Golf bag' },
			[63] = { ['object'] = 'hei_heist_kit_bin_01', ['price'] = 100, ['label'] = 'Garbage can' },
			[64] = { ['object'] = 'prop_wooden_barrel', ['price'] = 100, ['label'] = 'wooden vat' },
			[65] = { ['object'] = 'bkr_prop_bkr_cash_scatter_01', ['price'] = 100, ['label'] = 'scatter' },
			[66] = { ['object'] = 'bkr_prop_bkr_cashpile_01', ['price'] = 100, ['label'] = 'Cash' },
			[67] = { ['object'] = 'bkr_prop_bkr_cash_roll_01', ['price'] = 100, ['label'] = 'Cash roll' },
			[68] = { ['object'] = 'bkr_prop_bkr_cashpile_04', ['price'] = 100, ['label'] = 'pile of cash' },
			[69] = { ['object'] = 'bkr_prop_weed_bigbag_open_01a', ['price'] = 100, ['label'] = 'Weed open bag' },
			[70] = { ['object'] = 'bkr_prop_weed_bigbag_02a', ['price'] = 100, ['label'] = 'Weed bag 2' },
			[71] = { ['object'] = 'bkr_prop_weed_bigbag_03a', ['price'] = 100, ['label'] = 'Weed bag 3' },
			[72] = { ['object'] = 'bkr_prop_weed_scales_01a', ['price'] = 100, ['label'] = 'scales' },
			[73] = { ['object'] = 'bkr_prop_weed_smallbag_01a', ['price'] = 100, ['label'] = 'small bag' },
			[74] = { ['object'] = 'prop_gold_bar', ['price'] = 100, ['label'] = 'Gold Bar' },
			[75] = { ['object'] = 'beerrow_world', ['price'] = 100, ['label'] = 'beer bottles' },
			[76] = { ['object'] = 'beerrow_local', ['price'] = 100, ['label'] = 'beer bottles 2' },
			[77] = { ['object'] = 'p_cs_bbbat_01', ['price'] = 100, ['label'] = 'Bat' },
			[78] = { ['object'] = 'p_cs_cuffs_02_s', ['price'] = 100, ['label'] = 'handcuffs' },
			[79] = { ['object'] = 'p_cs_joint_02', ['price'] = 100, ['label'] = 'Joint' },
			[80] = { ['object'] = 'p_ing_coffeecup_01', ['price'] = 100, ['label'] = 'Coffee mug' },
			[81] = { ['object'] = 'p_tumbler_cs2_s', ['price'] = 100, ['label'] = 'Tumbler' },
			[82] = { ['object'] = 'prop_turkey_leg_01', ['price'] = 100, ['label'] = 'chicken leg' },
			[83] = { ['object'] = 'prop_amb_donut', ['price'] = 100, ['label'] = 'Donut' },
			[84] = { ['object'] = 'prop_donut_02', ['price'] = 100, ['label'] = 'Donut 2' },
			[85] = { ['object'] = 'prop_bar_shots', ['price'] = 100, ['label'] = 'Bar shots' },
			[86] = { ['object'] = 'prop_bar_stirrers', ['price'] = 100, ['label'] = 'Bar stirrers' },
			[87] = { ['object'] = 'prop_beer_amopen', ['price'] = 100, ['label'] = 'Beer open' },
			[88] = { ['object'] = 'prop_beer_blr', ['price'] = 100, ['label'] = 'Beer 1' },
			[89] = { ['object'] = 'prop_beer_logger', ['price'] = 100, ['label'] = 'Beer 2' },
			[90] = { ['object'] = 'prop_beer_stzopen', ['price'] = 100, ['label'] = 'Beer 3' },
			[91] = { ['object'] = 'prop_bikerset', ['price'] = 100, ['label'] = 'Biker Set' },
			[92] = { ['object'] = 'prop_bottle_brandy', ['price'] = 100, ['label'] = 'Bottle brandy' },
			[93] = { ['object'] = 'prop_tequila_bottle', ['price'] = 100, ['label'] = 'Tequila bottle' },
			[94] = { ['object'] = 'prop_tequila', ['price'] = 100, ['label'] = 'Tequila' },
			[95] = { ['object'] = 'prop_bottle_cognac', ['price'] = 100, ['label'] = 'Bottle of Cognac' },
			[96] = { ['object'] = 'prop_bottle_macbeth', ['price'] = 100, ['label'] = 'Bottle of Macbeth' },
			[97] = { ['object'] = 'prop_brandy_glass', ['price'] = 100, ['label'] = 'Brandy Glass' },
			[98] = { ['object'] = 'prop_mug_01', ['price'] = 100, ['label'] = 'Mug 1' },
			[99] = { ['object'] = 'prop_mug_02', ['price'] = 100, ['label'] = 'Mug 2' },
			[100] = { ['object'] = 'prop_mug_03', ['price'] = 100, ['label'] = 'Mug 3' },
			[101] = { ['object'] = 'prop_optic_vodka', ['price'] = 100, ['label'] = 'Vodka' },
			[102] = { ['object'] = 'prop_optic_jd', ['price'] = 100, ['label'] = 'JD' },
			[103] = { ['object'] = 'prop_pint_glass_01', ['price'] = 100, ['label'] = 'Pint Glass' },
			[104] = { ['object'] = 'prop_pizza_box_03', ['price'] = 100, ['label'] = 'Pizza box' },
			[105] = { ['object'] = 'prop_sandwich_01', ['price'] = 100, ['label'] = 'Sandwich' },
			[106] = { ['object'] = 'prop_cava', ['price'] = 100, ['label'] = 'Cava' },
			[107] = { ['object'] = 'prop_drink_redwine', ['price'] = 100, ['label'] = 'Red wine' },
			[108] = { ['object'] = 'vodkarow', ['price'] = 100, ['label'] = 'Vodka Row' },
			[109] = { ['object'] = 'prop_cherenkov_02', ['price'] = 100, ['label'] = 'Cherenkov' },
			[110] = { ['object'] = 'prop_cherenkov_03', ['price'] = 100, ['label'] = 'Cherenkov 2' },
			[111] = { ['object'] = 'prop_cocktail_glass', ['price'] = 100, ['label'] = 'Cocktail glass' },
			[112] = { ['object'] = 'prop_cs_bottle_opener', ['price'] = 100, ['label'] = 'Fles opener' },
			[113] = { ['object'] = 'prop_food_bs_chips', ['price'] = 100, ['label'] = 'Chips' },
			[114] = { ['object'] = 'prop_cs_burger_01', ['price'] = 100, ['label'] = 'Burger' },
			[115] = { ['object'] = 'prop_cs_hand_radio', ['price'] = 100, ['label'] = 'Hand radio' },
			[116] = { ['object'] = 'prop_cs_hotdog_01', ['price'] = 100, ['label'] = 'Hotdog' },
			[117] = { ['object'] = 'prop_cs_milk_01', ['price'] = 100, ['label'] = 'Milk' },
			[118] = { ['object'] = 'prop_cs_panties', ['price'] = 100, ['label'] = 'Panties' },
			[119] = { ['object'] = 'prop_cs_steak', ['price'] = 100, ['label'] = 'Meat' }
		},
	},
	['general3'] = {
		label = 'Random',
		items = {
			[1] = { ['object'] = 'v_ret_csr_bin', ['price'] = 100, ['label'] = 'CSR Bin' },
			[2] = { ['object'] = 'v_ret_fh_wickbskt', ['price'] = 100, ['label'] = 'Basket' },
			[3] = { ['object'] = 'v_ret_gc_bag01', ['price'] = 100, ['label'] = 'GC Bag 1' },
			[4] = { ['object'] = 'v_ret_gc_bag02', ['price'] = 100, ['label'] = 'GC Bag 2' },
			[5] = { ['object'] = 'v_ret_gc_bin', ['price'] = 100, ['label'] = 'GC Bin' },
			[6] = { ['object'] = 'v_ret_gc_cashreg', ['price'] = 100, ['label'] = 'Cash Register' },
			[7] = { ['object'] = 'v_ret_gc_chair01', ['price'] = 100, ['label'] = 'GC Chair 01' },
			[8] = { ['object'] = 'v_ret_gc_chair02', ['price'] = 100, ['label'] = 'GC Chair 02' },
			[9] = { ['object'] = 'v_ret_gc_clock', ['price'] = 100, ['label'] = 'Clock' },
			[10] = { ['object'] = 'v_ret_hd_prod1_', ['price'] = 100, ['label'] = 'Prod 1' },
			[11] = { ['object'] = 'v_ret_hd_prod2_', ['price'] = 100, ['label'] = 'Prod 2' },
			[12] = { ['object'] = 'v_ret_hd_prod3_', ['price'] = 100, ['label'] = 'Prod 3' },
			[13] = { ['object'] = 'v_ret_hd_prod4_', ['price'] = 100, ['label'] = 'Prod 4' },
			[14] = { ['object'] = 'v_ret_hd_prod5_', ['price'] = 100, ['label'] = 'Prod 5' },
			[15] = { ['object'] = 'v_ret_hd_prod6_', ['price'] = 100, ['label'] = 'Prod 6' },
			[16] = { ['object'] = 'v_ret_hd_unit1_', ['price'] = 100, ['label'] = 'HD Unit 1' },
			[17] = { ['object'] = 'v_ret_hd_unit2_', ['price'] = 100, ['label'] = 'HD Unit 2' },
			[18] = { ['object'] = 'v_ret_ml_fridge02', ['price'] = 100, ['label'] = 'Fridge' },
			[19] = { ['object'] = 'v_ret_ps_bag_01', ['price'] = 100, ['label'] = 'Bag 1' },
			[20] = { ['object'] = 'v_ret_ps_bag_02', ['price'] = 100, ['label'] = 'Bag 2' },
			[21] = { ['object'] = 'v_ret_ta_book1', ['price'] = 100, ['label'] = 'Book 1' },
			[22] = { ['object'] = 'v_ret_ta_book2', ['price'] = 100, ['label'] = 'Book 2' },
			[23] = { ['object'] = 'v_ret_ta_book3', ['price'] = 100, ['label'] = 'Book 3' },
			[24] = { ['object'] = 'v_ret_ta_book4', ['price'] = 100, ['label'] = 'Book 4' },
			[25] = { ['object'] = 'v_ret_ta_camera', ['price'] = 100, ['label'] = 'Cam' },
			[26] = { ['object'] = 'v_ret_ta_firstaid', ['price'] = 100, ['label'] = 'First Aid' },
			[27] = { ['object'] = 'v_ret_ta_hero', ['price'] = 100, ['label'] = 'Hero' },
			[28] = { ['object'] = 'v_ret_ta_mag1', ['price'] = 100, ['label'] = 'Mag 1' },
			[29] = { ['object'] = 'v_ret_ta_mag2', ['price'] = 100, ['label'] = 'Mag 2' },
			[30] = { ['object'] = 'v_ret_ta_skull', ['price'] = 100, ['label'] = 'Skull' },
			[31] = { ['object'] = 'prop_acc_guitar_01', ['price'] = 100, ['label'] = 'Guitar' },
			[32] = { ['object'] = 'prop_amb_handbag_01', ['price'] = 100, ['label'] = 'Handbag' },
			[33] = { ['object'] = 'prop_attache_case_01', ['price'] = 100, ['label'] = 'Case' },
			[34] = { ['object'] = 'prop_big_bag_01', ['price'] = 100, ['label'] = 'Big Bag' },
			[35] = { ['object'] = 'prop_bonesaw', ['price'] = 100, ['label'] = 'Bonesaw' },
			[36] = { ['object'] = 'prop_cs_fertilizer', ['price'] = 100, ['label'] = 'Fertilizer' },
			[37] = { ['object'] = 'prop_cs_shopping_bag', ['price'] = 100, ['label'] = 'Shopping Bag' },
			[38] = { ['object'] = 'prop_cs_vial_01', ['price'] = 100, ['label'] = 'Vial' },
			[39] = { ['object'] = 'prop_defilied_ragdoll_01', ['price'] = 100, ['label'] = 'Ragdoll' },
			[40] = { ['object'] = 'v_res_fa_book03', ['price'] = 100, ['label'] = 'boek kamasutra' },
			[41] = { ['object'] = 'prop_weight_rack_02', ['price'] = 500, ['label'] = 'dumbbellrek' },
			[42] = { ['object'] = 'prop_weight_bench_02', ['price'] = 500, ['label'] = 'Couchdrukset' },
			[43] = { ['object'] = 'prop_tool_broom', ['price'] = 100, ['label'] = 'Broom' },
			[44] = { ['object'] = 'prop_fire_exting_2a', ['price'] = 100, ['label'] = 'Fire extinguisher' },
			[45] = { ['object'] = 'v_res_vacuum', ['price'] = 100, ['label'] = 'vacuum cleaner' },
			[46] = { ['object'] = 'v_ret_gc_fan', ['price'] = 100, ['label'] = 'Fan' },
			[47] = { ['object'] = 'prop_paint_stepl01b', ['price'] = 100, ['label'] = 'ladder' },
			[48] = { ['object'] = 'bkr_prop_weed_bucket_01b', ['price'] = 100, ['label'] = 'Fertilizer' },
			[49] = { ['object'] = 'v_club_vusnaketank', ['price'] = 500, ['label'] = 'terrarium' },
			[50] = { ['object'] = 'prop_pooltable_02', ['price'] = 1500, ['label'] = 'poolTable' },
			[51] = { ['object'] = 'prop_pool_rack_02', ['price'] = 100, ['label'] = 'poolcues' },
			[52] = { ['object'] = 'v_club_vu_deckcase', ['price'] = 1000, ['label'] = 'dj set' },
			[53] = { ['object'] = 'v_corp_servercln', ['price'] = 1000, ['label'] = 'serverrack' }
		},
	},
	['general4'] = {
		label = 'Random 2',
		items = {
			[1] = { ['object'] = 'prop_dummy_01', ['price'] = 100, ['label'] = 'Dummy' },
			[2] = { ['object'] = 'prop_egg_clock_01', ['price'] = 100, ['label'] = 'Egg Clock' },
			[3] = { ['object'] = 'prop_el_guitar_01', ['price'] = 100, ['label'] = 'E Guitar 1' },
			[4] = { ['object'] = 'prop_el_guitar_02', ['price'] = 100, ['label'] = 'E Guitar 2' },
			[5] = { ['object'] = 'prop_el_guitar_03', ['price'] = 100, ['label'] = 'E Guitar 2' },
			[6] = { ['object'] = 'prop_feed_sack_01', ['price'] = 100, ['label'] = 'Feed Sack' },
			[7] = { ['object'] = 'prop_floor_duster_01', ['price'] = 100, ['label'] = 'Floor Duster' },
			[8] = { ['object'] = 'prop_fruit_basket', ['price'] = 100, ['label'] = 'Fruit Basket' },
			[9] = { ['object'] = 'prop_f_duster_02', ['price'] = 100, ['label'] = 'Duster' },
			[10] = { ['object'] = 'prop_grapes_02', ['price'] = 100, ['label'] = 'Grapes' },
			[11] = { ['object'] = 'prop_hotel_clock_01', ['price'] = 100, ['label'] = 'Hotel Clock' },
			[12] = { ['object'] = 'prop_idol_case_01', ['price'] = 100, ['label'] = 'Idol Case' },
			[13] = { ['object'] = 'prop_jewel_02a', ['price'] = 100, ['label'] = 'Jewels' },
			[14] = { ['object'] = 'prop_jewel_02b', ['price'] = 100, ['label'] = 'Jewels' },
			[15] = { ['object'] = 'prop_jewel_02c', ['price'] = 100, ['label'] = 'Jewels' },
			[16] = { ['object'] = 'prop_jewel_03a', ['price'] = 100, ['label'] = 'Jewels' },
			[17] = { ['object'] = 'prop_jewel_03b', ['price'] = 100, ['label'] = 'Jewels' },
			[18] = { ['object'] = 'prop_jewel_04a', ['price'] = 100, ['label'] = 'Jewels' },
			[19] = { ['object'] = 'prop_jewel_04b', ['price'] = 100, ['label'] = 'Jewels' },
			[20] = { ['object'] = 'prop_j_disptray_01', ['price'] = 100, ['label'] = 'Display Tray' },
			[21] = { ['object'] = 'prop_j_disptray_01b', ['price'] = 100, ['label'] = 'Display Tray' },
			[22] = { ['object'] = 'prop_j_disptray_02', ['price'] = 100, ['label'] = 'Display Tray' },
			[23] = { ['object'] = 'prop_j_disptray_03', ['price'] = 100, ['label'] = 'Display Tray' },
			[24] = { ['object'] = 'prop_j_disptray_04', ['price'] = 100, ['label'] = 'Display Tray' },
			[25] = { ['object'] = 'prop_j_disptray_04b', ['price'] = 100, ['label'] = 'Display Tray' },
			[26] = { ['object'] = 'prop_j_disptray_05', ['price'] = 100, ['label'] = 'Display Tray' },
			[27] = { ['object'] = 'prop_j_disptray_05b', ['price'] = 100, ['label'] = 'Display Tray' },
			[28] = { ['object'] = 'prop_ld_greenscreen_01', ['price'] = 100, ['label'] = 'Green Screen' },
			[29] = { ['object'] = 'prop_ld_handbag', ['price'] = 100, ['label'] = 'Handbag' },
			[30] = { ['object'] = 'prop_ld_jerrycan_01', ['price'] = 100, ['label'] = 'Jerry Can' },
			[31] = { ['object'] = 'prop_ld_keypad_01', ['price'] = 100, ['label'] = 'Keypad 1' },
			[32] = { ['object'] = 'prop_ld_keypad_01b', ['price'] = 100, ['label'] = 'Keypad 2' },
			[33] = { ['object'] = 'prop_ld_suitcase_01', ['price'] = 100, ['label'] = 'Suitcase 1' },
			[34] = { ['object'] = 'prop_ld_suitcase_02', ['price'] = 100, ['label'] = 'Suitcase 2' },
			[35] = { ['object'] = 'hei_p_attache_case_shut', ['price'] = 100, ['label'] = 'Suitcase 3' },
			[36] = { ['object'] = 'prop_mr_rasberryclean', ['price'] = 100, ['label'] = 'Rasberry Clean' },
			[37] = { ['object'] = 'prop_paper_bag_01', ['price'] = 100, ['label'] = 'Paper Bag' },
			[38] = { ['object'] = 'prop_shopping_bags01', ['price'] = 100, ['label'] = 'Shopping Bags' },
			[39] = { ['object'] = 'prop_shopping_bags02', ['price'] = 100, ['label'] = 'Shopping Bags 2' },
			[40] = { ['object'] = 'prop_yoga_mat_01', ['price'] = 100, ['label'] = 'Yoga Mat 1' },
			[41] = { ['object'] = 'prop_yoga_mat_02', ['price'] = 100, ['label'] = 'Yoga Mat 2' },
			[42] = { ['object'] = 'prop_yoga_mat_03', ['price'] = 100, ['label'] = 'Yoga Mat 3' },
			[43] = { ['object'] = 'p_ld_sax', ['price'] = 100, ['label'] = 'Sax' },
			[44] = { ['object'] = 'p_ld_soc_ball_01', ['price'] = 100, ['label'] = 'SOCCER Ball' },
			[45] = { ['object'] = 'p_watch_01', ['price'] = 100, ['label'] = 'Watch 1' },
			[46] = { ['object'] = 'p_watch_02', ['price'] = 100, ['label'] = 'Watch 2' },
			[47] = { ['object'] = 'p_watch_03', ['price'] = 100, ['label'] = 'Watch 3' },
			[48] = { ['object'] = 'p_watch_04', ['price'] = 100, ['label'] = 'Watch 4' },
			[49] = { ['object'] = 'p_watch_05', ['price'] = 100, ['label'] = 'Watch 5' },
			[50] = { ['object'] = 'p_watch_06', ['price'] = 100, ['label'] = 'Watch 6' },
			[51] = { ['object'] = 'apa_mp_h_acc_candles_01', ['price'] = 100, ['label'] = 'candle' },
			[52] = { ['object'] = 'apa_mp_h_acc_candles_02', ['price'] = 100, ['label'] = 'candle 2' },
			[53] = { ['object'] = 'apa_mp_h_acc_candles_04', ['price'] = 100, ['label'] = 'candle 3' },
			[54] = { ['object'] = 'apa_mp_h_acc_candles_06', ['price'] = 100, ['label'] = 'candle 4' },
			[55] = { ['object'] = 'apa_mp_h_acc_fruitbowl_02', ['price'] = 100, ['label'] = 'fruit bowl' },
			[56] = { ['object'] = 'apa_mp_h_acc_tray_01', ['price'] = 100, ['label'] = 'thingies' },
			[57] = { ['object'] = 'prop_bskball_01', ['price'] = 100, ['label'] = 'Basketball' },
			[58] = { ['object'] = 'prop_cs_wrench', ['price'] = 100, ['label'] = 'Wrench' },
			[59] = { ['object'] = 'prop_cs_bowie_knife', ['price'] = 100, ['label'] = 'Bowie Knife' },
			[60] = { ['object'] = 'prop_w_me_hatchet', ['price'] = 100, ['label'] = 'Hatchet' }
		},
	},
	['small'] = {
		label = 'Details',
		items = {
			[1] = { ['object'] = 'v_res_r_figcat', ['price'] = 300, ['label'] = 'Fig Cat' },
			[2] = { ['object'] = 'v_res_r_figclown', ['price'] = 300, ['label'] = 'Fig Clown' },
			[3] = { ['object'] = 'v_res_r_figauth2', ['price'] = 300, ['label'] = 'Fig Auth' },
			[4] = { ['object'] = 'v_res_r_figfemale', ['price'] = 300, ['label'] = 'Fig Female' },
			[5] = { ['object'] = 'v_res_r_figflamenco', ['price'] = 300, ['label'] = 'Fig Flamenco' },
			[6] = { ['object'] = 'v_res_r_figgirl', ['price'] = 300, ['label'] = 'Fig Girl' },
			[7] = { ['object'] = 'v_res_r_figgirlclown', ['price'] = 300, ['label'] = 'Fig Girl Clown' },
			[8] = { ['object'] = 'v_res_r_figoblisk', ['price'] = 300, ['label'] = 'Fig Oblisk' },
			[9] = { ['object'] = 'v_res_r_figpillar', ['price'] = 300, ['label'] = 'Fig Pillar' },
			[10] = { ['object'] = 'v_res_r_teapot', ['price'] = 300, ['label'] = 'Teapot' },
			[11] = { ['object'] = 'v_res_sculpt_dec', ['price'] = 300, ['label'] = 'Sculpture 1' },
			[12] = { ['object'] = 'v_res_sculpt_decd', ['price'] = 300, ['label'] = 'Sculpture 2' },
			[13] = { ['object'] = 'v_res_sculpt_dece', ['price'] = 300, ['label'] = 'Sculpture 3' },
			[14] = { ['object'] = 'v_res_sculpt_decf', ['price'] = 300, ['label'] = 'Sculpture 4' },
			[15] = { ['object'] = 'v_res_skateboard', ['price'] = 300, ['label'] = 'Skateboard' },
			[16] = { ['object'] = 'v_res_sketchpad', ['price'] = 300, ['label'] = 'Sketchpad' },
			[17] = { ['object'] = 'v_res_tissues', ['price'] = 300, ['label'] = 'Tissues' },
			[18] = { ['object'] = 'v_res_tre_basketmess', ['price'] = 300, ['label'] = 'Basket' },
			[19] = { ['object'] = 'v_res_tre_bin', ['price'] = 300, ['label'] = 'Bin' },
			[20] = { ['object'] = 'v_res_tre_cushiona', ['price'] = 300, ['label'] = 'Cushion 1' },
			[21] = { ['object'] = 'v_res_tre_cushionb', ['price'] = 300, ['label'] = 'Cushion 2' },
			[22] = { ['object'] = 'v_res_tre_cushionc', ['price'] = 300, ['label'] = 'Cushion 3' },
			[23] = { ['object'] = 'v_res_tre_cushiond', ['price'] = 300, ['label'] = 'Cushion 4' },
			[24] = { ['object'] = 'v_res_tre_cushnscuzb', ['price'] = 300, ['label'] = 'Cushion 5' },
			[25] = { ['object'] = 'v_res_tre_cushnscuzd', ['price'] = 300, ['label'] = 'Cushion 6' },
			[26] = { ['object'] = 'v_res_tre_fruitbowl', ['price'] = 300, ['label'] = 'Fruitbowl' },
			[27] = { ['object'] = 'v_med_p_sideboard', ['price'] = 300, ['label'] = 'Sideboard' },
			[28] = { ['object'] = 'prop_idol_01', ['price'] = 100, ['label'] = 'Idol 1' },
			[29] = { ['object'] = 'v_res_r_fighorsestnd', ['price'] = 300, ['label'] = 'Figurine black horse' },
			[30] = { ['object'] = 'v_res_r_fighorse', ['price'] = 300, ['label'] = 'Figurine big horse' },
			[31] = { ['object'] = 'v_res_r_figdancer', ['price'] = 300, ['label'] = 'Figurine dancer' },
			[32] = { ['object'] = 'v_res_fa_idol02', ['price'] = 300, ['label'] = 'olifanten Figurine' },
			[33] = { ['object'] = 'v_res_m_statue', ['price'] = 300, ['label'] = 'Sculpture' },
			[34] = { ['object'] = 'v_20_ornaeagle', ['price'] = 300, ['label'] = 'Figurine adelaar' },
			[35] = { ['object'] = 'v_med_p_vaseround', ['price'] = 300, ['label'] = 'Fase round' },
			[36] = { ['object'] = 'ex_mp_h_acc_vase_05', ['price'] = 300, ['label'] = 'Fase Violet' },
			[37] = { ['object'] = 'apa_mp_h_acc_dec_head_01', ['price'] = 300, ['label'] = 'Art work' },
			[38] = { ['object'] = 'apa_mp_h_acc_dec_sculpt_02', ['price'] = 300, ['label'] = 'Art work 2' },
			[39] = { ['object'] = 'ex_mp_h_acc_dec_plate_02', ['price'] = 300, ['label'] = 'Art work 3' },
			[40] = { ['object'] = 'apa_mp_h_acc_bowl_ceramic_01', ['price'] = 300, ['label'] = 'schaal' },
			[41] = { ['object'] = 'apa_mp_h_acc_dec_plate_01', ['price'] = 300, ['label'] = 'Scale 2' },
			[42] = { ['object'] = 'apa_mp_h_acc_vase_01', ['price'] = 300, ['label'] = 'vase black and white' },
			[43] = { ['object'] = 'apa_mp_h_acc_vase_02', ['price'] = 300, ['label'] = 'vase red' },
			[44] = { ['object'] = 'apa_mp_h_acc_vase_05', ['price'] = 300, ['label'] = 'vase' },
			[45] = { ['object'] = 'apa_mp_h_acc_vase_06', ['price'] = 300, ['label'] = 'vase black and white 2' }
		},
	},
	['storage'] = {
		label = 'Storage',
		items = {
			[1] = { ['object'] = 'v_res_cabinet', ['price'] = 2500, ['label'] = 'Cabinet Large' },
			[2] = { ['object'] = 'v_res_d_dressingtable', ['price'] = 2500, ['label'] = 'Dressing Table' },
			[3] = { ['object'] = 'v_res_d_sideunit', ['price'] = 2500, ['label'] = 'Side Unit' },
			[4] = { ['object'] = 'v_res_fh_sidebrddine', ['price'] = 2500, ['label'] = 'Side Unit' },
			[5] = { ['object'] = 'v_res_fh_sidebrdlngb', ['price'] = 2500, ['label'] = 'Side Unit' },
			[6] = { ['object'] = 'v_res_mbbedtable', ['price'] = 2500, ['label'] = 'Bed Unit' },
			[7] = { ['object'] = 'v_res_j_tvstand', ['price'] = 2500, ['label'] = 'Tv Unit' },
			[8] = { ['object'] = 'v_res_mbdresser', ['price'] = 2500, ['label'] = 'Dresser Unit' },
			[9] = { ['object'] = 'v_res_mbottoman', ['price'] = 2500, ['label'] = 'Bottoman Unit' },
			[10] = { ['object'] = 'v_res_mconsolemod', ['price'] = 2500, ['label'] = 'Console Unit' },
			[11] = { ['object'] = 'v_res_mcupboard', ['price'] = 2500, ['label'] = 'Cupboard Unit' },
			[12] = { ['object'] = 'v_res_mdchest', ['price'] = 2500, ['label'] = 'Chest Unit' },
			[13] = { ['object'] = 'v_res_msoncabinet', ['price'] = 2500, ['label'] = 'Mason Unit' },
			[14] = { ['object'] = 'v_res_m_armoire', ['price'] = 2500, ['label'] = 'Armoire Unit' },
			[15] = { ['object'] = 'v_res_m_sidetable', ['price'] = 2500, ['label'] = 'Side Unit' },
			[16] = { ['object'] = 'v_res_son_desk', ['price'] = 2500, ['label'] = 'Desk Unit' },
			[17] = { ['object'] = 'v_res_tre_bedsidetable', ['price'] = 2500, ['label'] = 'Side Unit' },
			[18] = { ['object'] = 'v_res_tre_bedsidetableb', ['price'] = 2500, ['label'] = 'Side Unit 2' },
			[19] = { ['object'] = 'v_res_tre_smallbookshelf', ['price'] = 2500, ['label'] = 'Book Unit' },
			[20] = { ['object'] = 'v_res_tre_storagebox', ['price'] = 2500, ['label'] = 'Box Unit' },
			[21] = { ['object'] = 'v_res_tre_storageunit', ['price'] = 2500, ['label'] = 'Storage Unit' },
			[22] = { ['object'] = 'v_res_tre_wardrobe', ['price'] = 2500, ['label'] = 'Wardrobe Unit' },
			[23] = { ['object'] = 'v_res_tre_wdunitscuz', ['price'] = 2500, ['label'] = 'Wood Unit' },
			[24] = { ['object'] = 'prop_devin_box_closed', ['price'] = 100, ['label'] = 'Bean Bag 1' },
			[25] = { ['object'] = 'prop_mil_crate_01', ['price'] = 100, ['label'] = 'Mil Crate 1' },
			[26] = { ['object'] = 'prop_mil_crate_02', ['price'] = 100, ['label'] = 'Mil Crate 2' },
			[27] = { ['object'] = 'prop_ld_int_safe_01', ['price'] = 1100, ['label'] = 'Safe' },
			[28] = { ['object'] = 'prop_toolchest_05', ['price'] = 5000, ['label'] = 'Crafting Bench' },
			[29] = { ['object'] = 'v_corp_filecablow', ['price'] = 500, ['label'] = 'Filing cabinet Low' },
			[30] = { ['object'] = 'v_corp_filecabtall', ['price'] = 500, ['label'] = 'Filing cabinet High' },
			[31] = { ['object'] = 'apa_mp_h_str_shelffloorm_02', ['price'] = 500, ['label'] = 'Large modern cupboard' },
			[32] = { ['object'] = 'v_ilev_frnkwarddr1', ['price'] = 500, ['label'] = 'Cupboard franklin' },
			[33] = { ['object'] = 'prop_coathook_01', ['price'] = 100, ['label'] = 'Coat rack' },
			[34] = { ['object'] = 'v_corp_lowcabdark01', ['price'] = 500, ['label'] = 'Filing cabinetLow black' },
			[35] = { ['object'] = 'v_corp_tallcabdark01', ['price'] = 500, ['label'] = 'Filing cabinet High black' },
			[36] = { ['object'] = 'v_corp_cabshelves01', ['price'] = 1000, ['label'] = 'Filing cabinet black' },
			[37] = { ['object'] = 'v_corp_offshelf', ['price'] = 1000, ['label'] = 'Filing cabinet groot' },
			[38] = { ['object'] = 'v_61_lng_mesh_unitc', ['price'] = 500, ['label'] = 'Bookcase white' },
			[39] = { ['object'] = 'ba_wardrobe', ['price'] = 500, ['label'] = 'kledingkast' },
			[40] = { ['object'] = 'apa_mp_h_str_sideboardl_06', ['price'] = 750, ['label'] = 'Cupboard  modern' },
			[41] = { ['object'] = 'apa_mp_h_str_sideboardl_09', ['price'] = 750, ['label'] = 'Cupboard  modern 2' },
			[42] = { ['object'] = 'apa_mp_h_str_shelfwallm_01', ['price'] = 750, ['label'] = 'Bookcase 2' },
			[43] = { ['object'] = 'apa_mp_h_str_sideboardl_11', ['price'] = 750, ['label'] = 'Cupboard  modern 3' },
			[44] = { ['object'] = 'imp_prop_impexp_parts_rack_03a', ['price'] = 750, ['label'] = 'car parts' },
			[45] = { ['object'] = 'imp_prop_impexp_parts_rack_04a', ['price'] = 750, ['label'] = 'car parts 2' },
			[46] = { ['object'] = 'imp_prop_impexp_parts_rack_05a', ['price'] = 750, ['label'] = 'car parts 3' },
			[47] = { ['object'] = 'apa_mp_h_bed_chestdrawer_02', ['price'] = 750, ['label'] = 'chest of drawers' },
			[48] = { ['object'] = 'hei_heist_bed_chestdrawer_04', ['price'] = 750, ['label'] = 'chest of drawers 2' },
			[49] = { ['object'] = 'prop_rub_cabinet', ['price'] = 50, ['label'] = 'rusted filing cabinet' },
			[50] = { ['object'] = 'prop_tv_cabinet_03', ['price'] = 750, ['label'] = 'tv little cupboard' },
			[51] = { ['object'] = 'prop_tv_cabinet_04', ['price'] = 750, ['label'] = 'tv little cupboard 2' },
			[52] = { ['object'] = 'prop_tv_cabinet_05', ['price'] = 750, ['label'] = 'tv little cupboard 3' },
			[53] = { ['object'] = 'apa_mp_h_str_shelffreel_01', ['price'] = 750, ['label'] = 'ikea closet' },
			[54] = { ['object'] = 'apa_mp_h_str_sideboardl_13', ['price'] = 750, ['label'] = 'cabinet modern 4' },
			[55] = { ['object'] = 'apa_mp_h_str_sideboardl_14', ['price'] = 750, ['label'] = 'cabinet modern 5' },
			[56] = { ['object'] = 'apa_mp_h_str_sideboardm_02', ['price'] = 750, ['label'] = 'cabinet modern 6' },
			[57] = { ['object'] = 'bkr_prop_biker_garage_locker_01', ['price'] = 750, ['label'] = 'Biker Locker' },
			[58] = { ['object'] = 'gr_prop_gr_bench_04b', ['price'] = 750, ['label'] = 'Biker Bench' }
		},
	},
	['electronics'] = {
		label = 'Electronics',
		items = {
			[1] = { ['object'] = 'prop_trailr_fridge', ['price'] = 300, ['label'] = 'Old Fridge' },
			[2] = { ['object'] = 'v_res_fh_speaker', ['price'] = 300, ['label'] = 'Speaker' },
			[3] = { ['object'] = 'v_res_fh_speakerdock', ['price'] = 300, ['label'] = 'Speaker Dock' },
			[4] = { ['object'] = 'v_res_fh_bedsideclock', ['price'] = 300, ['label'] = 'Bedside Clock' },
			[5] = { ['object'] = 'v_res_fa_phone', ['price'] = 300, ['label'] = 'Phone' },
			[6] = { ['object'] = 'v_res_fh_towerfan', ['price'] = 300, ['label'] = 'Tower Fan' },
			[7] = { ['object'] = 'v_res_fa_fan', ['price'] = 300, ['label'] = 'Fan' },
			[8] = { ['object'] = 'v_res_lest_bigscreen', ['price'] = 300, ['label'] = 'Bigscreen' },
			[9] = { ['object'] = 'v_res_lest_monitor', ['price'] = 300, ['label'] = 'Monitor' },
			[10] = { ['object'] = 'v_res_tre_mixer', ['price'] = 300, ['label'] = 'Mixer' },
			[11] = { ['object'] = 'prop_cs_cctv', ['price'] = 100, ['label'] = 'CCTV' },
			[12] = { ['object'] = 'prop_ld_lap_top', ['price'] = 100, ['label'] = 'Laptop' },
			[13] = { ['object'] = 'prop_ld_monitor_01', ['price'] = 100, ['label'] = 'Monitor' },
			[14] = { ['object'] = 'prop_speaker_05', ['price'] = 500, ['label'] = 'mounted speaker' },
			[15] = { ['object'] = 'prop_tv_flat_03b', ['price'] = 1000, ['label'] = 'kleine flatscreen' },
			[16] = { ['object'] = 'prop_laptop_01a', ['price'] = 750, ['label'] = 'Open laptop' },
			[17] = { ['object'] = 'prop_tv_flat_michael', ['price'] = 3000, ['label'] = 'flatscreen hanging ing' },
			[18] = { ['object'] = 'prop_dyn_pc', ['price'] = 1000, ['label'] = 'pc' },
			[19] = { ['object'] = 'prop_keyboard_01b', ['price'] = 100, ['label'] = 'Keybord' },
			[20] = { ['object'] = 'prop_mouse_01b', ['price'] = 100, ['label'] = 'Computer mouse' },
			[21] = { ['object'] = 'v_ret_gc_phone', ['price'] = 100, ['label'] = 'office phone' },
			[22] = { ['object'] = 'prop_tv_flat_01', ['price'] = 5000, ['label'] = 'Big flatscreen' },
			[23] = { ['object'] = 'prop_arcade_01', ['price'] = 5000, ['label'] = 'arcade' },
			[24] = { ['object'] = 'prop_console_01', ['price'] = 250, ['label'] = 'gameconsole' },
			[25] = { ['object'] = 'v_res_tre_dvdplayer', ['price'] = 250, ['label'] = 'dvd Player' },
			[26] = { ['object'] = 'prop_speaker_08', ['price'] = 500, ['label'] = 'wooden speaker' },
			[27] = { ['object'] = 'prop_cctv_mon_02', ['price'] = 300, ['label'] = 'cctv monitor' },
			[28] = { ['object'] = 'prop_tv_flat_02', ['price'] = 2500, ['label'] = 'flatscreen Standing' },
			[29] = { ['object'] = 'prop_cctv_cam_01a', ['price'] = 300, ['label'] = 'cctv 2' },
			[30] = { ['object'] = 'prop_dest_cctv_02', ['price'] = 300, ['label'] = 'cctv monitor 2' },
			[31] = { ['object'] = 'prop_cctv_cam_07a', ['price'] = 300, ['label'] = 'cctv 3' },
			[32] = { ['object'] = 'apa_mp_h_str_avunits_04', ['price'] = 5500, ['label'] = 'flatscreen meubel' },
			[33] = { ['object'] = 'apa_mp_h_str_avunits_01', ['price'] = 5500, ['label'] = 'flatscreen meubel 2' },
			[34] = { ['object'] = 'v_club_vu_deckcase', ['price'] = 1000, ['label'] = 'dj set' },
			[35] = { ['object'] = 'v_corp_servercln', ['price'] = 1000, ['label'] = 'serverrack' },
			[36] = { ['object'] = 'apa_mp_h_str_avunitl_01_b', ['price'] = 5500, ['label'] = 'flat screen furniture 3' },
			[37] = { ['object'] = 'apa_mp_h_str_avunitl_04', ['price'] = 5500, ['label'] = 'flat screen furniture 4' },
			[38] = { ['object'] = 'apa_mp_h_str_avunitm_01', ['price'] = 5500, ['label'] = 'flat screen furniture 5' },
			[39] = { ['object'] = 'apa_mp_h_str_avunitm_03', ['price'] = 5500, ['label'] = 'flat screen furniture 6' },
			[40] = { ['object'] = 'apa_mp_h_str_avunits_04', ['price'] = 5500, ['label'] = 'flat screen furniture 7' },
			[41] = { ['object'] = 'v_res_--printer', ['price'] = 300, ['label'] = '--printer' },
			[42] = { ['object'] = 'apa_mp_h_acc_phone_01', ['price'] = 100, ['label'] = 'old fashioned telephone' },
			[43] = { ['object'] = 'v_res_mousemat', ['price'] = 300, ['label'] = 'mouse pad' },
			[44] = { ['object'] = 'v_res_pcheadset', ['price'] = 300, ['label'] = 'headset' },
			[45] = { ['object'] = 'v_res_pcspeaker', ['price'] = 300, ['label'] = 'PC speaker' },
			[46] = { ['object'] = 'ba_prop_battle_club_speaker_small', ['price'] = 500, ['label'] = 'small box' },
			[47] = { ['object'] = 'ba_prop_battle_club_speaker_med', ['price'] = 750, ['label'] = 'box' },
			[48] = { ['object'] = 'ba_prop_battle_club_speaker_large', ['price'] = 1000, ['label'] = 'big box' },
			[49] = { ['object'] = 'v_res_pcspeaker', ['price'] = 300, ['label'] = 'PC speaker' },
			[50] = { ['object'] = 'v_res_pcwoofer', ['price'] = 300, ['label'] = 'PC subwoofer' },
			[51] = { ['object'] = 'prop_controller_01', ['price'] = 300, ['label'] = 'Controller' },
			[52] = { ['object'] = 'prop_cs_remote_01', ['price'] = 300, ['label'] = 'Remote control' },
			[53] = { ['object'] = 'prop_portable_hifi_01', ['price'] = 300, ['label'] = 'Radio' },
			[54] = { ['object'] = 'prop_dj_deck_02', ['price'] = 300, ['label'] = 'DJ table' },
			[55] = { ['object'] = 'prop_speaker_01', ['price'] = 300, ['label'] = 'Speaker' }
		},
	},
	['lighting'] = {
		label = 'Lighting',
		items = {
			[1] = { ['object'] = 'v_corp_cd_desklamp', ['price'] = 100, ['label'] = 'Desk Corp Lamp' },
			[2] = { ['object'] = 'v_res_desklamp', ['price'] = 100, ['label'] = 'Desk Lamp' },
			[3] = { ['object'] = 'v_res_d_lampa', ['price'] = 100, ['label'] = 'Lamp AA' },
			[4] = { ['object'] = 'v_res_fa_lamp1on', ['price'] = 100, ['label'] = 'Lamp 1' },
			[5] = { ['object'] = 'v_res_fh_floorlamp', ['price'] = 100, ['label'] = 'Floor Lamp' },
			[6] = { ['object'] = 'v_res_fh_lampa_on', ['price'] = 100, ['label'] = 'Lamp 2' },
			[7] = { ['object'] = 'v_res_j_tablelamp1', ['price'] = 100, ['label'] = 'Table Lamp' },
			[8] = { ['object'] = 'v_res_j_tablelamp2', ['price'] = 100, ['label'] = 'Table Lamp 2' },
			[9] = { ['object'] = 'v_res_mdbedlamp', ['price'] = 100, ['label'] = 'Bed Lamp' },
			[10] = { ['object'] = 'v_res_mplanttongue', ['price'] = 100, ['label'] = 'Plant Tongue Lamp' },
			[11] = { ['object'] = 'v_res_mtblelampmod', ['price'] = 100, ['label'] = 'Table Lamp 3' },
			[12] = { ['object'] = 'v_res_m_lampstand', ['price'] = 100, ['label'] = 'Lamp Stand' },
			[13] = { ['object'] = 'v_res_m_lampstand2', ['price'] = 100, ['label'] = 'Lamp Stand 2' },
			[14] = { ['object'] = 'v_res_m_lamptbl', ['price'] = 100, ['label'] = 'Table Lamp 4' },
			[15] = { ['object'] = 'v_res_tre_lightfan', ['price'] = 100, ['label'] = 'Light Fan' },
			[16] = { ['object'] = 'v_res_tre_talllamp', ['price'] = 100, ['label'] = 'Tall Lamp' },
			[17] = { ['object'] = 'v_ret_fh_walllighton', ['price'] = 100, ['label'] = 'Wall Light' },
			[18] = { ['object'] = 'v_ret_gc_lamp', ['price'] = 100, ['label'] = 'GC Lamp' },
			[19] = { ['object'] = 'prop_dummy_light', ['price'] = 100, ['label'] = 'Flickering Light' },
			[20] = { ['object'] = 'prop_ld_cont_light_01', ['price'] = 100, ['label'] = 'Side Wall Light' },
			[21] = { ['object'] = 'V_44_D_emis', ['price'] = 100, ['label'] = 'Test Light' },
			[22] = { ['object'] = 'prop_wall_light_07a', ['price'] = 100, ['label'] = 'lantaarn' },
			[23] = { ['object'] = 'prop_wall_light_01a', ['price'] = 100, ['label'] = 'Cheap lamp' },
			[24] = { ['object'] = 'v_serv_tu_light2_', ['price'] = 100, ['label'] = 'industrieel licht' },
			[25] = { ['object'] = 'v_serv_tu_light3_', ['price'] = 100, ['label'] = 'industrieel licht2' },
			[26] = { ['object'] = 'ba_prop_battle_lights_ceiling_l_a', ['price'] = 300, ['label'] = 'hanging lamp' },
			[27] = { ['object'] = 'v_med_p_floorlamp', ['price'] = 300, ['label'] = 'Big lamp' },
			[28] = { ['object'] = 'v_club_vu_lamp', ['price'] = 100, ['label'] = 'Smal lamp' },
			[29] = { ['object'] = 'ba_prop_battle_lights_wall_l_a', ['price'] = 100, ['label'] = 'Wall lamp' },
			[30] = { ['object'] = 'ba_prop_battle_lights_ceiling_l_c', ['price'] = 300, ['label'] = 'hanging lamp 2' },
			[31] = { ['object'] = 'ba_prop_battle_lights_ceiling_l_b', ['price'] = 300, ['label'] = 'kroonluchter 2' },
			[32] = { ['object'] = 'ba_prop_battle_lights_wall_l_c', ['price'] = 100, ['label'] = 'Wall lamp 2' },
			[33] = { ['object'] = 'ba_prop_battle_lights_wall_l_b', ['price'] = 100, ['label'] = 'Wall lamp 3' },
			[34] = { ['object'] = 'hei_heist_lit_lightpendant_02', ['price'] = 300, ['label'] = 'hanging lamp 3' },
			[35] = { ['object'] = 'prop_oldlight_01b', ['price'] = 100, ['label'] = 'wall lamp 4' },
			[36] = { ['object'] = 'apa_mp_h_lit_floorlampnight_07', ['price'] = 100, ['label'] = 'blue lamp' },
			[37] = { ['object'] = 'apa_mp_h_ceiling_light_01', ['price'] = 100, ['label'] = 'commercial' },
			[38] = { ['object'] = 'apa_mp_h_ceiling_light_01_day', ['price'] = 100, ['label'] = 'commercial 2' },
			[39] = { ['object'] = 'apa_mp_h_ceiling_light_02', ['price'] = 100, ['label'] = 'ceiling light' },
			[40] = { ['object'] = 'apa_mp_h_ceiling_light_02_day', ['price'] = 100, ['label'] = 'ceiling light 2' },
			[41] = { ['object'] = 'ba_prop_battle_lights_ceiling_l_d', ['price'] = 100, ['label'] = 'commercial 3' },
			[42] = { ['object'] = 'ba_prop_battle_lights_ceiling_l_f', ['price'] = 100, ['label'] = 'ceiling light 3' },
			[43] = { ['object'] = 'ba_prop_battle_lights_ceiling_l_e', ['price'] = 100, ['label'] = 'ceiling light 4' },
			[44] = { ['object'] = 'apa_mp_h_floorlamp_a', ['price'] = 100, ['label'] = 'floor lamp' },
			[45] = { ['object'] = 'apa_mp_h_floorlamp_b', ['price'] = 100, ['label'] = 'floor lamp 2' },
			[46] = { ['object'] = 'apa_mp_h_floorlamp_c', ['price'] = 100, ['label'] = 'floor lamp 3' },
			[47] = { ['object'] = 'apa_mp_h_floor_lamp_int_08', ['price'] = 100, ['label'] = 'floor lamp 4' },
			[48] = { ['object'] = 'apa_mp_h_lampbulb_multiple_a', ['price'] = 100, ['label'] = 'ceiling light 5' },
			[49] = { ['object'] = 'apa_mp_h_lit_floorlamp_02', ['price'] = 100, ['label'] = 'floor lamp 5' },
			[50] = { ['object'] = 'apa_mp_h_lit_floorlampnight_14', ['price'] = 100, ['label'] = 'floor lamp 6' },
			[51] = { ['object'] = 'apa_mp_h_lit_floorlamp_03', ['price'] = 100, ['label'] = 'floor lamp 7' },
			[52] = { ['object'] = 'apa_mp_h_lit_floorlamp_06', ['price'] = 100, ['label'] = 'floor lamp 8' },
			[53] = { ['object'] = 'apa_mp_h_lit_floorlamp_10', ['price'] = 100, ['label'] = 'floor lamp 9' },
			[54] = { ['object'] = 'apa_mp_h_lit_floorlamp_13', ['price'] = 100, ['label'] = 'floor lamp 10' },
			[55] = { ['object'] = 'apa_mp_h_lit_floorlamp_17', ['price'] = 100, ['label'] = 'floor lamp 11' },
			[56] = { ['object'] = 'apa_mp_h_lit_lamptablenight_16', ['price'] = 100, ['label'] = 'night light' },
			[57] = { ['object'] = 'apa_mp_h_lit_lamptablenight_24', ['price'] = 100, ['label'] = 'night light 2' },
			[58] = { ['object'] = 'apa_mp_h_lit_lamptable_005', ['price'] = 100, ['label'] = 'night light 3' },
			[59] = { ['object'] = 'apa_mp_h_lit_lamptable_04', ['price'] = 100, ['label'] = 'night light 4' },
			[60] = { ['object'] = 'apa_mp_h_lit_lamptable_09', ['price'] = 100, ['label'] = 'night light 5' },
			[61] = { ['object'] = 'apa_mp_h_lit_lamptable_14', ['price'] = 100, ['label'] = 'night light 6' },
			[62] = { ['object'] = 'apa_mp_h_lit_lamptable_17', ['price'] = 100, ['label'] = 'night light 7' },
			[63] = { ['object'] = 'apa_mp_h_yacht_table_lamp_01', ['price'] = 100, ['label'] = 'night light 8' }
		},
	},
	['tables'] = {
		label = 'Tables',
		items = {
			[1] = { ['object'] = 'v_res_d_coffeetable', ['price'] = 500, ['label'] = 'Coffee Table 1' },
			[2] = { ['object'] = 'v_res_d_roundtable', ['price'] = 500, ['label'] = 'Round Table' },
			[3] = { ['object'] = 'v_res_d_smallsidetable', ['price'] = 500, ['label'] = 'Small Side Table' },
			[4] = { ['object'] = 'v_res_fh_coftablea', ['price'] = 500, ['label'] = 'Table A' },
			[5] = { ['object'] = 'v_res_fh_coftableb', ['price'] = 500, ['label'] = 'Table B' },
			[6] = { ['object'] = 'v_res_fh_coftbldisp', ['price'] = 500, ['label'] = 'Table C' },
			[7] = { ['object'] = 'v_res_fh_diningtable', ['price'] = 500, ['label'] = 'Dining Table' },
			[8] = { ['object'] = 'v_res_j_coffeetable', ['price'] = 500, ['label'] = 'Coffee Table 2' },
			[9] = { ['object'] = 'v_res_j_lowtable', ['price'] = 500, ['label'] = 'Low Table' },
			[10] = { ['object'] = 'v_res_mdbedtable', ['price'] = 500, ['label'] = 'Bed Table' },
			[11] = { ['object'] = 'v_res_mddesk', ['price'] = 500, ['label'] = 'Desk' },
			[12] = { ['object'] = 'v_res_msidetblemod', ['price'] = 500, ['label'] = 'Side Table' },
			[13] = { ['object'] = 'v_res_m_console', ['price'] = 500, ['label'] = 'Console Table' },
			[14] = { ['object'] = 'v_res_m_dinetble_replace', ['price'] = 500, ['label'] = 'Dining Table 2' },
			[15] = { ['object'] = 'v_res_m_h_console', ['price'] = 500, ['label'] = 'Console H Table' },
			[16] = { ['object'] = 'v_res_m_stool', ['price'] = 500, ['label'] = 'Stool?' },
			[17] = { ['object'] = 'v_res_tre_sideboard', ['price'] = 500, ['label'] = 'Sideboard Table' },
			[18] = { ['object'] = 'v_res_tre_table2', ['price'] = 500, ['label'] = 'Table 2' },
			[19] = { ['object'] = 'v_res_tre_tvstand', ['price'] = 500, ['label'] = 'Tv Table' },
			[20] = { ['object'] = 'v_res_tre_tvstand_tall', ['price'] = 500, ['label'] = 'Tv Table Tall' },
			[21] = { ['object'] = 'v_med_p_coffeetable', ['price'] = 500, ['label'] = 'Med Coffee Table' },
			[22] = { ['object'] = 'v_med_p_desk', ['price'] = 500, ['label'] = 'Med Desk' },
			[23] = { ['object'] = 'prop_yacht_table_01', ['price'] = 100, ['label'] = 'Yacht Table 1' },
			[24] = { ['object'] = 'prop_yacht_table_02', ['price'] = 100, ['label'] = 'Yacht Table 2' },
			[25] = { ['object'] = 'prop_yacht_table_03', ['price'] = 100, ['label'] = 'Yacht Table 3' },
			[26] = { ['object'] = 'v_ret_csr_table', ['price'] = 100, ['label'] = 'CSR Table' },
			[27] = { ['object'] = 'v_res_mconsoletrad', ['price'] = 250, ['label'] = 'high side table' },
			[28] = { ['object'] = 'v_ilev_liconftable_sml', ['price'] = 500, ['label'] = 'Office tabel' },
			[29] = { ['object'] = 'v_ret_tablesml', ['price'] = 350, ['label'] = 'Side table  marillaux' },
			[30] = { ['object'] = 'apa_mp_h_yacht_coffee_table_02', ['price'] = 500, ['label'] = 'koffie table Brown' },
			[31] = { ['object'] = 'apa_mp_h_yacht_side_table_01', ['price'] = 300, ['label'] = 'Side table Brown' },
			[32] = { ['object'] = 'apa_mp_h_yacht_side_table_02', ['price'] = 300, ['label'] = 'ronde Side table' },
			[33] = { ['object'] = 'apa_mp_h_tab_sidelrg_04', ['price'] = 300, ['label'] = 'ronde Side table 2' },
			[34] = { ['object'] = 'v_club_vu_table', ['price'] = 300, ['label'] = 'Coverd Table' },
			[35] = { ['object'] = 'apa_mp_h_tab_sidelrg_07', ['price'] = 500, ['label'] = 'koffieTable glas' },
			[36] = { ['object'] = 'bkr_prop_weed_table_01b', ['price'] = 100, ['label'] = 'clapTable' },
			[37] = { ['object'] = 'ba_prop_int_trad_table', ['price'] = 300, ['label'] = 'Stand Table' },
			[38] = { ['object'] = 'apa_mp_h_str_sideboards_02', ['price'] = 750, ['label'] = 'Side table glas' },
			[39] = { ['object'] = 'apa_mp_h_yacht_coffee_table_01', ['price'] = 750, ['label'] = 'koffieTable modern' },
			[40] = { ['object'] = 'apa_mp_h_din_table_04', ['price'] = 1000, ['label'] = 'dinner Table glas' },
			[41] = { ['object'] = 'xm_prop_base_staff_desk_01', ['price'] = 5000, ['label'] = 'desk + setup' },
			[42] = { ['object'] = 'apa_mp_h_tab_coffee_07', ['price'] = 1000, ['label'] = 'triangular side table' },
			[43] = { ['object'] = 'apa_mp_h_tab_coffee_08', ['price'] = 1000, ['label'] = 'white side table' },
			[44] = { ['object'] = 'apa_mp_h_tab_sidelrg_01', ['price'] = 1000, ['label'] = 'glass side table' },
			[45] = { ['object'] = 'apa_mp_h_tab_sidelrg_02', ['price'] = 1000, ['label'] = 'glass side table 2' },
			[46] = { ['object'] = 'apa_mp_h_tab_sidesml_01', ['price'] = 1000, ['label'] = 'folding table' },
			[47] = { ['object'] = 'ba_prop_int_edgy_table_01', ['price'] = 500, ['label'] = 'table marble' },
			[48] = { ['object'] = 'ba_prop_int_edgy_table_02', ['price'] = 500, ['label'] = 'table marble high' },
			[49] = { ['object'] = 'apa_mp_h_tab_sidelrg_01', ['price'] = 1000, ['label'] = 'glass side table' },
			[50] = { ['object'] = 'xm_prop_lab_desk_01', ['price'] = 1000, ['label'] = 'lab table' }
		},
	},
	['plants'] = {
		label = 'Plants',
		items = {
			[1] = { ['object'] = 'prop_fib_plant_01', ['price'] = 150, ['label'] = 'Plant Fib' },
			[2] = { ['object'] = 'v_corp_bombplant', ['price'] = 170, ['label'] = 'Plant Bomb' },
			[3] = { ['object'] = 'v_res_mflowers', ['price'] = 170, ['label'] = 'Plant Flowers' },
			[4] = { ['object'] = 'v_res_mvasechinese', ['price'] = 170, ['label'] = 'Plant Chinese' },
			[5] = { ['object'] = 'v_res_m_bananaplant', ['price'] = 170, ['label'] = 'Plant Banana' },
			[6] = { ['object'] = 'v_res_m_palmplant1', ['price'] = 170, ['label'] = 'Plant Palm' },
			[7] = { ['object'] = 'v_res_m_palmstairs', ['price'] = 170, ['label'] = 'Plant Palm 2' },
			[8] = { ['object'] = 'v_res_m_urn', ['price'] = 170, ['label'] = 'Plant Urn' },
			[9] = { ['object'] = 'v_res_rubberplant', ['price'] = 170, ['label'] = 'Plant Rubber' },
			[10] = { ['object'] = 'v_res_tre_plant', ['price'] = 170, ['label'] = 'Plant' },
			[11] = { ['object'] = 'v_res_tre_tree', ['price'] = 170, ['label'] = 'Plant Tree' },
			[12] = { ['object'] = 'v_med_p_planter', ['price'] = 170, ['label'] = 'Planter' },
			[13] = { ['object'] = 'v_ret_flowers', ['price'] = 100, ['label'] = 'Flowers' },
			[14] = { ['object'] = 'v_ret_j_flowerdisp', ['price'] = 100, ['label'] = 'Flowers 1' },
			[15] = { ['object'] = 'v_ret_j_flowerdisp_white', ['price'] = 100, ['label'] = 'Flowers 2' },
			[16] = { ['object'] = 'v_res_m_vasefresh', ['price'] = 300, ['label'] = 'FlowerFase' },
			[17] = { ['object'] = 'v_res_rosevasedead', ['price'] = 300, ['label'] = 'Pink Fase 2' },
			[18] = { ['object'] = 'v_res_exoticvase', ['price'] = 300, ['label'] = 'FlowerFase 2' },
			[19] = { ['object'] = 'v_res_rosevase', ['price'] = 300, ['label'] = 'Pink Fase' },
			[20] = { ['object'] = 'prop_pot_plant_6a', ['price'] = 300, ['label'] = 'Hanging ende plant' },
			[21] = { ['object'] = 'prop_pot_plant_02a', ['price'] = 300, ['label'] = 'Flower pot' },
			[22] = { ['object'] = 'apa_mp_h_acc_plant_palm_01', ['price'] = 300, ['label'] = 'palm plant' },
			[23] = { ['object'] = 'prop_plant_interior_05a', ['price'] = 300, ['label'] = 'flower box' },
			[24] = { ['object'] = 'prop_plant_int_01a', ['price'] = 300, ['label'] = 'plant' },
			[25] = { ['object'] = 'prop_plant_int_01b', ['price'] = 300, ['label'] = 'plant 2' },
			[26] = { ['object'] = 'prop_plant_int_02a', ['price'] = 300, ['label'] = 'plant 3' },
			[27] = { ['object'] = 'prop_plant_int_02b', ['price'] = 300, ['label'] = 'plant 4' },
			[28] = { ['object'] = 'prop_plant_int_03a', ['price'] = 300, ['label'] = 'plant 5' },
			[29] = { ['object'] = 'prop_plant_int_03b', ['price'] = 300, ['label'] = 'plant 6' },
			[30] = { ['object'] = 'prop_plant_int_03c', ['price'] = 300, ['label'] = 'plant 7' },
			[31] = { ['object'] = 'prop_plant_int_04a', ['price'] = 300, ['label'] = 'plant 8' },
			[32] = { ['object'] = 'prop_plant_int_04c', ['price'] = 300, ['label'] = 'plant 9' },
			[33] = { ['object'] = 'prop_plant_int_05b', ['price'] = 300, ['label'] = 'flower box 2' },
			[34] = { ['object'] = 'prop_pot_plant_01a', ['price'] = 300, ['label'] = 'plant pot 2' },
			[35] = { ['object'] = 'prop_pot_plant_01b', ['price'] = 300, ['label'] = 'plant pot 3' },
			[36] = { ['object'] = 'prop_pot_plant_01c', ['price'] = 300, ['label'] = 'plant pot 4' },
			[37] = { ['object'] = 'prop_pot_plant_01d', ['price'] = 300, ['label'] = 'plant pot 5' },
			[38] = { ['object'] = 'prop_pot_plant_01e', ['price'] = 300, ['label'] = 'plant pot 6' },
			[39] = { ['object'] = 'prop_pot_plant_03b', ['price'] = 300, ['label'] = 'plant pot 7' },
			[40] = { ['object'] = 'prop_pot_plant_05a', ['price'] = 300, ['label'] = 'plant pot 8' },
			[41] = { ['object'] = 'prop_pot_plant_05b', ['price'] = 300, ['label'] = 'plant pot 9' },
			[42] = { ['object'] = 'p_int_jewel_plant_01', ['price'] = 300, ['label'] = 'plant pot 10' },
			[43] = { ['object'] = 'p_int_jewel_plant_02', ['price'] = 300, ['label'] = 'plant pot 11' },
			[44] = { ['object'] = 'apa_mp_h_acc_vase_flowers_01', ['price'] = 300, ['label'] = 'plant pot 12' },
			[45] = { ['object'] = 'apa_mp_h_acc_vase_flowers_02', ['price'] = 300, ['label'] = 'plant pot 13' },
			[46] = { ['object'] = 'apa_mp_h_acc_vase_flowers_03', ['price'] = 300, ['label'] = 'plant pot 14' },
			[47] = { ['object'] = 'apa_mp_h_acc_vase_flowers_04', ['price'] = 300, ['label'] = 'plant pot 15' }
		},
	},
	['kitchen'] = {
		label = 'Kitchen',
		items = {
			[1] = { ['object'] = 'prop_washer_01', ['price'] = 150, ['label'] = 'Washer 1' },
			[2] = { ['object'] = 'prop_washer_02', ['price'] = 150, ['label'] = 'Washer 2' },
			[3] = { ['object'] = 'prop_washer_03', ['price'] = 150, ['label'] = 'Washer 3' },
			[4] = { ['object'] = 'prop_washing_basket_01', ['price'] = 150, ['label'] = 'Washing Basket' },
			[5] = { ['object'] = 'v_res_fridgemoda', ['price'] = 150, ['label'] = 'Fridge 1' },
			[6] = { ['object'] = 'v_res_fridgemodsml', ['price'] = 150, ['label'] = 'Fridge 2' },
			[7] = { ['object'] = 'prop_fridge_01', ['price'] = 150, ['label'] = 'Fridge 3' },
			[8] = { ['object'] = 'prop_fridge_03', ['price'] = 150, ['label'] = 'Fridge 4' },
			[9] = { ['object'] = 'prop_cooker_03', ['price'] = 150, ['label'] = 'Cooker' },
			[10] = { ['object'] = 'prop_micro_01', ['price'] = 150, ['label'] = 'Microwave 1' },
			[11] = { ['object'] = 'prop_micro_02', ['price'] = 150, ['label'] = 'Microwave 2' },
			[12] = { ['object'] = 'prop_wok', ['price'] = 150, ['label'] = 'Wok' },
			[13] = { ['object'] = 'v_res_cakedome', ['price'] = 150, ['label'] = 'Cake Plate' },
			[14] = { ['object'] = 'v_res_fa_chopbrd', ['price'] = 150, ['label'] = 'Chopping Board' },
			[15] = { ['object'] = 'v_res_mutensils', ['price'] = 150, ['label'] = 'Utensils' },
			[16] = { ['object'] = 'v_res_pestle', ['price'] = 150, ['label'] = 'Pestle' },
			[17] = { ['object'] = 'v_ret_ta_paproll', ['price'] = 150, ['label'] = 'PaperRoll 1' },
			[18] = { ['object'] = 'v_ret_ta_paproll2', ['price'] = 150, ['label'] = 'PaperRoll 2' },
			[19] = { ['object'] = 'v_ret_fh_pot01', ['price'] = 150, ['label'] = 'Pot 1' },
			[20] = { ['object'] = 'v_ret_fh_pot02', ['price'] = 150, ['label'] = 'Pot 2' },
			[21] = { ['object'] = 'v_ret_fh_pot05', ['price'] = 150, ['label'] = 'Pot 3' },
			[22] = { ['object'] = 'prop_pot_03', ['price'] = 150, ['label'] = 'Pot 4' },
			[23] = { ['object'] = 'prop_pot_04', ['price'] = 150, ['label'] = 'Pot 5' },
			[24] = { ['object'] = 'prop_pot_05', ['price'] = 150, ['label'] = 'Pot 6' },
			[25] = { ['object'] = 'prop_pot_06', ['price'] = 150, ['label'] = 'Pot 7' },
			[26] = { ['object'] = 'prop_pot_rack', ['price'] = 150, ['label'] = 'Pot Rack' },
			[27] = { ['object'] = 'prop_kitch_juicer', ['price'] = 150, ['label'] = 'Juicer' },
			[28] = { ['object'] = 'v_res_ovenhobmod', ['price'] = 1000, ['label'] = 'Stove' },
			[29] = { ['object'] = 'v_res_mkniferack', ['price'] = 100, ['label'] = 'Knive' },
			[30] = { ['object'] = 'v_res_mchopboard', ['price'] = 100, ['label'] = 'Cutting plank' },
			[31] = { ['object'] = 'prop_cs_kitchen_cab_l', ['price'] = 750, ['label'] = 'Kitchen Cupboard Wide' },
			[32] = { ['object'] = 'prop_cs_kitchen_cab_r', ['price'] = 500, ['label'] = 'Kitchen cupboard smal' },
			[33] = { ['object'] = 'prop_cs_kitchen_cab_r', ['price'] = 500, ['label'] = 'Kitchen cupboard smal' },
			[34] = { ['object'] = 'v_res_tre_fridge', ['price'] = 500, ['label'] = 'refrigerator' },
			[35] = { ['object'] = 'apa_mp_h_acc_coffeemachine_01', ['price'] = 500, ['label'] = 'coffee machine' },
			[36] = { ['object'] = 'p_new_j_counter_02', ['price'] = 500, ['label'] = 'Counter' },
			[37] = { ['object'] = 'prop_bar_pump_09', ['price'] = 500, ['label'] = 'Pump 1' },
			[38] = { ['object'] = 'prop_bar_pump_01', ['price'] = 500, ['label'] = 'Pump 2' },
			[39] = { ['object'] = 'prop_chip_fryer', ['price'] = 500, ['label'] = 'Chips fryer' },
			[40] = { ['object'] = 'prop_cleaver', ['price'] = 500, ['label'] = 'Knife' },
			[41] = { ['object'] = 'prop_coffee_mac_02', ['price'] = 500, ['label'] = 'coffee machine' },
			[42] = { ['object'] = 'prop_coffee_mac_01', ['price'] = 500, ['label'] = 'coffee machine 2' },
			[43] = { ['object'] = 'prop_cs_fork', ['price'] = 500, ['label'] = 'Fork' },
			[44] = { ['object'] = 'prop_cs_sink_filler', ['price'] = 500, ['label'] = 'Sink filler' },
			[45] = { ['object'] = 'prop_toaster_01', ['price'] = 500, ['label'] = 'Toaster' },
			[46] = { ['object'] = 'prop_cs_plate_01', ['price'] = 500, ['label'] = 'Plate' },
			[47] = { ['object'] = 'prop_foodprocess_01', ['price'] = 500, ['label'] = 'Food Process' },
			[48] = { ['object'] = 'prop_food_sugarjar', ['price'] = 500, ['label'] = 'Sugar Bowl' },
			[49] = { ['object'] = 'prop_juice_dispenser', ['price'] = 500, ['label'] = 'Dispencer' },
			[50] = { ['object'] = 'prop_knife_stand', ['price'] = 500, ['label'] = 'Knife holder' },
			[51] = { ['object'] = 'prop_knife', ['price'] = 500, ['label'] = 'Knife 2' },
			[52] = { ['object'] = 'prop_micro_04', ['price'] = 500, ['label'] = 'Microwave 4' },
			[53] = { ['object'] = 'v_ret_fh_plate3', ['price'] = 500, ['label'] = 'Plate 5' },
			[54] = { ['object'] = 'v_ilev_tt_plate01', ['price'] = 500, ['label'] = 'Plate 6' },
			[55] = { ['object'] = 'v_res_fa_grater', ['price'] = 500, ['label'] = 'Grater' },
			[56] = { ['object'] = 'v_res_tt_pizzaplate', ['price'] = 500, ['label'] = 'Pizza Plate' },
			[57] = { ['object'] = 'v_ret_247_ketchup2', ['price'] = 500, ['label'] = 'Ketchup' }
		},
	},
	['bathroom'] = {
		label = 'Bathroom',
		items = {
			[1] = { ['object'] = 'prop_ld_toilet_01', ['price'] = 100, ['label'] = 'Toilet 1' },
			[2] = { ['object'] = 'prop_toilet_01', ['price'] = 100, ['label'] = 'Toilet 2' },
			[3] = { ['object'] = 'prop_toilet_02', ['price'] = 100, ['label'] = 'Toilet 3' },
			[4] = { ['object'] = 'prop_sink_02', ['price'] = 100, ['label'] = 'Sink 1' },
			[5] = { ['object'] = 'prop_sink_04', ['price'] = 100, ['label'] = 'Sink 2' },
			[6] = { ['object'] = 'prop_sink_05', ['price'] = 100, ['label'] = 'Sink 3' },
			[7] = { ['object'] = 'prop_sink_06', ['price'] = 100, ['label'] = 'Sink 4' },
			[8] = { ['object'] = 'prop_soap_disp_01', ['price'] = 100, ['label'] = 'Soap Dispenser' },
			[9] = { ['object'] = 'prop_shower_rack_01', ['price'] = 100, ['label'] = 'Shower Rack' },
			[10] = { ['object'] = 'prop_handdry_01', ['price'] = 100, ['label'] = 'Hand Dryer 1' },
			[11] = { ['object'] = 'prop_handdry_02', ['price'] = 100, ['label'] = 'Hand Dryer 2' },
			[12] = { ['object'] = 'prop_towel_rail_01', ['price'] = 100, ['label'] = 'Towel Rail 1' },
			[13] = { ['object'] = 'prop_towel_rail_02', ['price'] = 100, ['label'] = 'Towel Rail 2' },
			[14] = { ['object'] = 'prop_towel_01', ['price'] = 100, ['label'] = 'Towel 1' },
			[15] = { ['object'] = 'v_res_mbtowel', ['price'] = 100, ['label'] = 'Towel 2' },
			[16] = { ['object'] = 'v_res_mbtowelfld', ['price'] = 100, ['label'] = 'Towel 3' },
			[17] = { ['object'] = 'v_res_mbath', ['price'] = 100, ['label'] = 'Bath' },
			[18] = { ['object'] = 'v_res_mbsink', ['price'] = 100, ['label'] = 'Sink' },
			[19] = { ['object'] = 'v_ilev_mm_faucet', ['price'] = 100, ['label'] = 'tap' },
			[20] = { ['object'] = 'v_res_tre_washbasket', ['price'] = 250, ['label'] = 'Washing mand' },
			[21] = { ['object'] = 'prop_toilet_soap_02', ['price'] = 100, ['label'] = 'Tray Soap' },
			[22] = { ['object'] = 'prop_bar_sink_01', ['price'] = 100, ['label'] = 'Sink' },
			[23] = { ['object'] = 'apa_mp_h_bathtub_01', ['price'] = 1000, ['label'] = 'Bath' },
			[24] = { ['object'] = 'prop_toilet_brush_01', ['price'] = 1000, ['label'] = 'Brush' },
			[25] = { ['object'] = 'prop_toilet_roll_01', ['price'] = 1000, ['label'] = 'Toilet rol' },
			[26] = { ['object'] = 'prop_toilet_roll_02', ['price'] = 1000, ['label'] = 'Toilet rol 2' },
			[27] = { ['object'] = 'prop_toilet_shamp_01', ['price'] = 1000, ['label'] = 'Shampoo' },
			[28] = { ['object'] = 'prop_toilet_shamp_02', ['price'] = 1000, ['label'] = 'Shampoo 2' }
		},
	},
	['medical'] = {
		label = 'Medical',
		items = {
			[1] = { ['object'] = 'v_med_barrel', ['price'] = 750, ['label'] = 'Barrel' },
			[2] = { ['object'] = 'v_med_apecrate', ['price'] = 750, ['label'] = 'Ape Crate' },
			[3] = { ['object'] = 'v_med_apecratelrg', ['price'] = 750, ['label'] = 'Ape Crate Large' },
			[4] = { ['object'] = 'v_med_bed1', ['price'] = 750, ['label'] = 'Bed 1' },
			[5] = { ['object'] = 'v_med_bed2', ['price'] = 750, ['label'] = 'Bed 2' },
			[6] = { ['object'] = 'v_med_bedtable', ['price'] = 750, ['label'] = 'Bed Table' },
			[7] = { ['object'] = 'v_med_bench1', ['price'] = 750, ['label'] = 'Bench 1' },
			[8] = { ['object'] = 'v_med_bench2', ['price'] = 750, ['label'] = 'Bench 2' },
			[9] = { ['object'] = 'v_med_benchcentr', ['price'] = 750, ['label'] = 'Bench Center' },
			[10] = { ['object'] = 'v_med_benchset1', ['price'] = 750, ['label'] = 'Bench Set' },
			[11] = { ['object'] = 'v_med_bigtable', ['price'] = 750, ['label'] = 'Big Table' },
			[12] = { ['object'] = 'v_med_bin', ['price'] = 150, ['label'] = 'Bin' },
			[13] = { ['object'] = 'v_med_centrifuge1', ['price'] = 750, ['label'] = 'Centrifuge' },
			[14] = { ['object'] = 'v_med_cooler', ['price'] = 750, ['label'] = 'Cooler' },
			[15] = { ['object'] = 'v_med_cor_ceilingmonitor', ['price'] = 750, ['label'] = 'Monitor' },
			[16] = { ['object'] = 'v_med_cor_autopsytbl', ['price'] = 750, ['label'] = 'Autopsy Table' },
			[17] = { ['object'] = 'v_med_cor_cembin', ['price'] = 750, ['label'] = 'Bin' },
			[18] = { ['object'] = 'v_med_cor_cemtrolly2', ['price'] = 750, ['label'] = 'Trolley' },
			[19] = { ['object'] = 'v_med_cor_chemical', ['price'] = 750, ['label'] = 'Chem' },
			[20] = { ['object'] = 'v_med_cor_emblmtable', ['price'] = 750, ['label'] = 'BLM Table' },
			[21] = { ['object'] = 'v_med_cor_fileboxa', ['price'] = 750, ['label'] = 'File Box' },
			[22] = { ['object'] = 'v_med_cor_filingcab', ['price'] = 750, ['label'] = 'File Cab' },
			[23] = { ['object'] = 'v_med_cor_hose', ['price'] = 750, ['label'] = 'Hose' },
			[24] = { ['object'] = 'v_med_cor_largecupboard', ['price'] = 750, ['label'] = 'Large Cupboard' },
			[25] = { ['object'] = 'v_med_cor_lightbox', ['price'] = 750, ['label'] = 'Lightbox' },
			[26] = { ['object'] = 'v_med_cor_medstool', ['price'] = 750, ['label'] = 'Medstool' },
			[27] = { ['object'] = 'v_med_cor_minifridge', ['price'] = 750, ['label'] = 'Minifridge' },
			[28] = { ['object'] = 'v_med_cor_papertowels', ['price'] = 750, ['label'] = 'Papertowels' },
			[29] = { ['object'] = 'v_med_cor_photocopy', ['price'] = 750, ['label'] = 'Photocopy' },
			[30] = { ['object'] = 'v_med_cor_tvstand', ['price'] = 750, ['label'] = 'TV Stand' },
			[31] = { ['object'] = 'v_med_cor_wallunita', ['price'] = 750, ['label'] = 'Wall Unit' },
			[32] = { ['object'] = 'v_med_examlight', ['price'] = 750, ['label'] = 'Exam light' },
			[33] = { ['object'] = 'v_med_gastank', ['price'] = 750, ['label'] = 'Gas Tank' },
			[34] = { ['object'] = 'v_med_hazmatscan', ['price'] = 750, ['label'] = 'Hazmat Scan' },
			[35] = { ['object'] = 'v_med_hospheadwall1', ['price'] = 750, ['label'] = 'Head Wall' },
			[36] = { ['object'] = 'v_med_hospseating1', ['price'] = 750, ['label'] = 'Seating' },
			[37] = { ['object'] = 'v_med_hosptable', ['price'] = 750, ['label'] = 'Hosp Table' },
			[38] = { ['object'] = 'v_med_latexgloveboxblue', ['price'] = 50, ['label'] = 'Glove Box' },
			[39] = { ['object'] = 'v_med_medwastebin', ['price'] = 750, ['label'] = 'Wastebin' },
			[40] = { ['object'] = 'v_med_oscillator3', ['price'] = 750, ['label'] = 'Oscillator' },
			[41] = { ['object'] = 'prop_ld_health_pack', ['price'] = 100, ['label'] = 'Health Pack' },
		},
	},
	['walldecoration'] = {
		label = 'Wall  Deco',
		items = {
			[1] = { ['object'] = 'apa_p_h_acc_artwalll_02', ['price'] = 1000, ['label'] = 'Painting whit marks' },
			[2] = { ['object'] = 'v_ind_cs_toolboard', ['price'] = 500, ['label'] = 'Tools' },
			[3] = { ['object'] = 'apa_mp_stilts_bed_art', ['price'] = 300, ['label'] = '3d art' },
			[4] = { ['object'] = 'ex_office_swag_paintings03', ['price'] = 1000, ['label'] = 'Paintingen Ground' },
			[5] = { ['object'] = 'ex_mp_h_acc_artwallm_03', ['price'] = 750, ['label'] = 'abstract Painting' },
			[6] = { ['object'] = 'ex_p_h_acc_artwallm_04', ['price'] = 750, ['label'] = 'abstract Painting 2' },
			[7] = { ['object'] = 'ex_p_h_acc_artwalll_01', ['price'] = 1250, ['label'] = 'abstract Painting Big' },
			[8] = { ['object'] = 'apa_p_h_acc_artwalll_03', ['price'] = 750, ['label'] = 'abstract Painting 3' },
			[9] = { ['object'] = 'ex_mp_h_acc_artwallm_02', ['price'] = 750, ['label'] = 'abstract Painting 4' },
			[10] = { ['object'] = 'ex_p_h_acc_artwallm_03', ['price'] = 750, ['label'] = 'abstract Painting 5' },
			[11] = { ['object'] = 'apa_mp_stilts_a_study_pics', ['price'] = 500, ['label'] = 'Paintingen' },
			[12] = { ['object'] = 'apa_mp_h_acc_artwallm_02', ['price'] = 750, ['label'] = 'abstract Painting 6' },
			[13] = { ['object'] = 'apa_mp_h_acc_artwalll_02', ['price'] = 750, ['label'] = 'abstract Painting 7' },
			[14] = { ['object'] = 'apa_mp_h_acc_artwallm_04', ['price'] = 750, ['label'] = 'abstract Painting 8' },
			[15] = { ['object'] = 'prop_dart_bd_cab_01', ['price'] = 250, ['label'] = 'Dartboard' },
			[16] = { ['object'] = 'prop_dart_bd_01', ['price'] = 250, ['label'] = 'Dartboard 2' },
			[17] = { ['object'] = 'hei_heist_acc_artwalll_01', ['price'] = 250, ['label'] = 'wall deco 1' },
			[18] = { ['object'] = 'hei_heist_acc_artgolddisc_01', ['price'] = 250, ['label'] = 'wall deco 2' },
			[19] = { ['object'] = 'hei_heist_acc_artgolddisc_02', ['price'] = 250, ['label'] = 'wall deco 3' },
			[20] = { ['object'] = 'hei_heist_acc_artgolddisc_03', ['price'] = 250, ['label'] = 'wall deco 4' },
			[21] = { ['object'] = 'hei_heist_acc_artgolddisc_04', ['price'] = 250, ['label'] = 'wall deco 5' },
			[22] = { ['object'] = 'v_ilev_ra_doorsafe', ['price'] = 250, ['label'] = 'Luxury deco' }
		},
	},
}

-- Functions

local function openDecorateUI()
	SetNuiFocus(true, true)
	cursorEnabled = true
	SendNUIMessage({
		type = 'openObjects',
		furniture = Furniture,
	})
	SetCursorLocation(0.5, 0.5)
end

local function closeDecorateUI()
	SetNuiFocus(false, false)
  --print("TOGGLING CURSOR OFF69")
	cursorEnabled = false
	SendNUIMessage({
		type = 'closeUI',
	})
end

local function CreateEditCamera()
	local rot = GetEntityRotation(PlayerPedId())
	local pos = GetEntityCoords(PlayerPedId(), true)
	MainCamera = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 60.00, false, 0)
	SetCamActive(MainCamera, true)
	RenderScriptCams(true, false, 1, true, true)
end

local function EnableEditMode()
	local pos = GetEntityCoords(PlayerPedId(), true)
	curPos = { x = pos.x, y = pos.y, z = pos.z }
	SetEntityVisible(PlayerPedId(), false)
	FreezeEntityPosition(PlayerPedId(), true)
	SetEntityCollision(PlayerPedId(), false, false)
	CreateEditCamera()
	DecoMode = true

end

local function SaveDecorations()
	if ClosestHouse then
		if SelectedObj then
			if SelObjId ~= 0 then
				ObjectList[SelObjId] = { hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = SelObjId }
			else
				if ObjectList then
					ObjectList[#ObjectList + 1] = { hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = #ObjectList + 1 }
				else
					ObjectList[1] = { hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = 1 }
				end
			end

			for _, v in pairs(ObjectList) do
				DeleteObject(v.object)
    
			end
		end

		TriggerServerEvent('RoJea_property:savedecorations', ClosestHouse, ObjectList)

	end
end

local function SetDefaultCamera()
	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(MainCamera, false)
	DestroyCam(MainCamera, true)
	DestroyAllCams(true)
end

local sentNotif = false

local function DisableEditMode()
	SaveDecorations()
	SetEntityVisible(PlayerPedId(), true)
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityCollision(PlayerPedId(), true, true)
	SetDefaultCamera()
	EnableAllControlActions(0)
	ObjectList = nil
	SelectedObj = nil
	peanut = false
	DecoMode = false
end

local cachedObjPos

local function CheckObjMovementInput()
	local xVect = speeds[curSpeed]
	local yVect = speeds[curSpeed]
	local zVect = speeds[curSpeed]

	if IsControlPressed(1, 27) or IsDisabledControlPressed(1, 27) then -- Up Arrow
		SelObjPos = GetOffsetFromEntityInWorldCoords(SelectedObj, 0, -yVect, 0)
	end

	if IsControlPressed(1, 173) or IsDisabledControlPressed(1, 173) then -- Down Arrow
		SelObjPos = GetOffsetFromEntityInWorldCoords(SelectedObj, 0, yVect, 0)
	end

	if IsControlPressed(1, 174) or IsDisabledControlPressed(1, 174) then -- Left Arrow
		SelObjPos = GetOffsetFromEntityInWorldCoords(SelectedObj, xVect, 0, 0)
	end

	if IsControlPressed(1, 175) or IsDisabledControlPressed(1, 175) then -- Right Arrow
		SelObjPos = GetOffsetFromEntityInWorldCoords(SelectedObj, -xVect, 0, 0)
	end

	if IsControlPressed(1, 10) or IsDisabledControlPressed(1, 10) then -- Page Up
		SelObjPos = GetOffsetFromEntityInWorldCoords(SelectedObj, 0, 0, zVect)
	end

	if IsControlPressed(1, 11) or IsDisabledControlPressed(1, 11) then -- Page Down
		SelObjPos = GetOffsetFromEntityInWorldCoords(SelectedObj, 0, 0, -zVect)
	end

  cachedObjPos = GetEntityCoords(SelectedObj)

  

	SetEntityCoords(SelectedObj, SelObjPos.x, SelObjPos.y, SelObjPos.z)
  if GetInteriorFromEntity(SelectedObj)==0 then
    SetEntityCoords(SelectedObj, cachedObjPos)
    if sentNotif == false then
      sentNotif = true
      TriggerEvent("esx:showNotification", "~r~Negalite išnešti objekto i lauka!")
      SetTimeout(3000, function()sentNotif = false end)
    end
  end
end

local function CheckObjRotationInput()
	local xVect = speeds[curSpeed] * 5.5
	local yVect = speeds[curSpeed] * 5.5
	local zVect = speeds[curSpeed] * 5.5

	if IsControlPressed(1, 27) or IsDisabledControlPressed(1, 27) then -- Up Arrow
		SelObjRot.x = SelObjRot.x + xVect
	end

	if IsControlPressed(1, 173) or IsDisabledControlPressed(1, 173) then -- Down Arrow
		SelObjRot.x = SelObjRot.x - xVect
	end

	if IsControlPressed(1, 174) or IsDisabledControlPressed(1, 174) then -- Left Arrow
		SelObjRot.z = SelObjRot.z + zVect
	end

	if IsControlPressed(1, 175) or IsDisabledControlPressed(1, 175) then -- Right Arrow
		SelObjRot.z = SelObjRot.z - zVect
	end

	if IsControlPressed(1, 10) or IsDisabledControlPressed(1, 10) then -- Page Up
		SelObjRot.y = SelObjRot.y + yVect
	end

	if IsControlPressed(1, 11) or IsDisabledControlPressed(1, 11) then -- Page Down
		SelObjRot.y = SelObjRot.y - yVect
	end

	SetEntityRotation(SelectedObj, SelObjRot.x, SelObjRot.y, SelObjRot.z)
end

local function CheckRotationInput()
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(MainCamera, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		local new_z = rotation.z + rightAxisX * -1.0 * (2.0) * (4.0 + 0.1)
		local new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (2.0) * (4.0 + 0.1)), -20.5)
		SetCamRot(MainCamera, new_x, 0.0, new_z, 2)
	end
end

local function getTableLength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

local function degToRad(degs)
	return degs * 3.141592653589793 / 180
end

local function CheckMovementInput()
	local rotation = GetCamRot(MainCamera, 2)

	if IsControlJustReleased(0, 21) then -- Left Shift
		curSpeed = curSpeed + 1
		if curSpeed > getTableLength(speeds) then
			curSpeed = 1
		end
		-- QBCore.Functions.Notify(Lang:t('info.speed') .. tostring(speeds[curSpeed]))
    ESX.ShowNotification("Nustatete nauja greiti: " .. tostring(speeds[curSpeed]))
	end

	local xVect = speeds[curSpeed] * math.sin(degToRad(rotation.z)) * -1.0
	local yVect = speeds[curSpeed] * math.cos(degToRad(rotation.z))
	local zVect = speeds[curSpeed] * math.tan(degToRad(rotation.x) - degToRad(rotation.y))

	if IsControlPressed(1, 32) or IsDisabledControlPressed(1, 32) then -- W
		curPos.x = curPos.x + xVect
		curPos.y = curPos.y + yVect
		curPos.z = curPos.z + zVect
	end

	if IsControlPressed(1, 33) or IsDisabledControlPressed(1, 33) then -- S
		curPos.x = curPos.x - xVect
		curPos.y = curPos.y - yVect
		curPos.z = curPos.z - zVect
	end

	SetCamCoord(MainCamera, curPos.x, curPos.y, curPos.z)
end

-- Events

RegisterNetEvent('RoJea_property:global:decorate', function()
	Wait(500)

	-- if IsInside then
		-- if HasHouseKey then
			if not DecoMode then
				EnableEditMode()
				openDecorateUI()
			end
	-- 	else
	-- 		QBCore.Functions.Notify(Lang:t('error.no_keys'), 'error')
	-- 	end
	-- else
	-- 	QBCore.Functions.Notify(Lang:t('error.not_in_house'), 'error')
	-- end
end)

-- NUI Callbacks

RegisterNUICallback('closedecorations', function(_, cb)
	if previewObj then
		DeleteObject(previewObj)
	end
	DisableEditMode()
	SetNuiFocus(false, false)
  --print("TOGGLING CURSOR OFF")
	cursorEnabled = false
	cb('ok')
end)

RegisterNUICallback('deleteSelectedObject', function(_, cb)
	DeleteObject(SelectedObj)
	SelectedObj = nil
	table.remove(ObjectList, SelObjId)
	Wait(100)
	SaveDecorations()
	SelObjId = 0
	peanut = false
	cb('ok')
end)

RegisterNUICallback('cancelSelectedObject', function(_, cb)
	DeleteObject(SelectedObj)
	SelectedObj = nil
	SelObjId = 0
	peanut = false
	cb('ok')
end)

RegisterNUICallback('buySelectedObject', function(data, cb)
	ESX.TSC('RoJea_property:buyFurniture', function(isSuccess)

		if isSuccess then
      
			SetNuiFocus(false, false)
      --print("TOGGLING CURSOR OFF2")
			cursorEnabled = false
			SaveDecorations()
			SelectedObj = nil
			SelObjId = 0
			peanut = false
		else
			DeleteObject(SelectedObj)
			SelectedObj = nil
			SelObjId = 0
			peanut = false
		end
		cb('ok')
	end, ClosestHouse, data.price)
end)

RegisterNUICallback('setupMyObjects', function(_, cb)
	local Objects = {}
	for k, v in pairs(ObjectList) do
		if ObjectList[k] then
			Objects[#Objects + 1] = {
				rotx = v.rotx,
				object = v.object,
				y = v.y,
				hashname = v.hashname,
				x = v.x,
				rotz = v.rotz,
				objectId = v.objectId,
				roty = v.roty,
				z = v.z,
			}
		end
	end
	Wait(100)

	cb(Objects)
end)

RegisterNUICallback('removeObject', function(_, cb)
	if previewObj then
		DeleteObject(previewObj)
	end
	cb('ok')
end)

local justEnabled = false

RegisterNUICallback('toggleCursor', function(_, cb)
	--cursorEnabled = not cursorEnabled
  if justEnabled then return cb('ok') end
  cursorEnabled = false
	SetNuiFocus(cursorEnabled, cursorEnabled)
	cb('ok')
end)

RegisterNUICallback('selectOwnedObject', function(data, cb)
	local objectData = data.objectData
	local ownedObject = GetClosestObjectOfType(objectData.x, objectData.y, objectData.z, 1.5, GetHashKey(objectData.hashname), false, 6, 7)
	local pos = GetEntityCoords(ownedObject, true)
	local rot = GetEntityRotation(ownedObject)
	SelObjRot = { x = rot.x, y = rot.y, z = rot.z }
	SelObjPos = { x = pos.x, y = pos.y, z = pos.z }
	SelObjHash = objectData.hashname
	SelObjId = objectData.objectId
	SelectedObj = ownedObject
	FreezeEntityPosition(SelectedObj, true)
	peanut = true
	cb('ok')
end)

RegisterNUICallback('editOwnedObject', function(data, cb)
	SetNuiFocus(false, false)
  --print('cursor off by edit')
	cursorEnabled = false
	local objectData = data.objectData
	local ownedObject = GetClosestObjectOfType(objectData.x, objectData.y, objectData.z, 1.5, GetHashKey(objectData.hashname), false, 6, 7)
	local pos = GetEntityCoords(ownedObject, true)
	local rot = GetEntityRotation(ownedObject)
	SelObjRot = { x = rot.x, y = rot.y, z = rot.z }
	SelObjPos = { x = pos.x, y = pos.y, z = pos.z }
	SelObjHash = objectData.hashname
	SelObjId = objectData.objectId
	SelectedObj = ownedObject
	isEdit = true
	FreezeEntityPosition(SelectedObj, true)
	peanut = true
	cb('ok')
end)

RegisterNUICallback('deselectOwnedObject', function(_, cb)
	SelectedObj = nil
	peanut = false
	cb('ok')
end)

RegisterNUICallback('ResetSelectedProp', function(_, cb)
	SelectedObj = nil
	peanut = false
	cb('ok')
end)

RegisterNUICallback('spawnobject', function(data, cb)
	SetNuiFocus(false, false)
  --print("TOGGLING CURSOR OFF3")
	cursorEnabled = false
	if previewObj then
		DeleteObject(previewObj)
	end
	local modelHash = GetHashKey(tostring(data.object))
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Wait(1000)
	end
	local rotation = GetCamRot(MainCamera, 2)
	local xVect = 2.5 * math.sin(degToRad(rotation.z)) * -1.0
	local yVect = 2.5 * math.cos(degToRad(rotation.z))
	SelectedObj = CreateObject(modelHash, curPos.x + xVect, curPos.y + yVect, curPos.z, false, false, false)
	local pos = GetEntityCoords(SelectedObj, true)
	local rot = GetEntityRotation(SelectedObj)
	SelObjRot = { x = rot.x, y = rot.y, z = rot.z }
	SelObjPos = { x = pos.x, y = pos.y, z = pos.z }
	SelObjHash = data.object
	PlaceObjectOnGroundProperly(SelectedObj)
	SetEntityCompletelyDisableCollision(SelectedObj, true) -- Prevents crazy physics when collidin with other entitys
  peanut = true


  if GetInteriorFromEntity(SelectedObj) == 0 then
    DeleteObject(SelectedObj)
    SelectedObj = nil
    SelObjId = 0
    peanut = false
    TriggerEvent("esx:showNotification", "~r~Pasukite kamera i kambario vidu, kad baldas neatsispawnintu lauke!")
    TriggerEvent("esx:showNotification", "~y~Jeigu esate namo viduje, reiškia jusu namas nera pritaikytas baldams...")
    Wait(200)
    DisableEditMode()
		closeDecorateUI()
    return cb('ok')
  end
	
	cb('ok')
end)

RegisterNUICallback('chooseobject', function(data, cb)
	if previewObj then
		DeleteObject(previewObj)
	end
	local modelHash = GetHashKey(tostring(data.object))
	RequestModel(modelHash)

	local count = 0
	while not HasModelLoaded(modelHash) do
		-- Counter to prevent infinite loading when object does not exist
		if count > 10 then
			break
		end
		count = count + 1
		Wait(1000)
	end

	-- Make buttons selectable again
	SendNUIMessage({
		type = 'objectLoaded',
	})

	local rotation = GetCamRot(MainCamera, 2)
	local xVect = 2.5 * math.sin(degToRad(rotation.z)) * -1.0
	local yVect = 2.5 * math.cos(degToRad(rotation.z))
	previewObj = CreateObject(modelHash, curPos.x + xVect, curPos.y + yVect, curPos.z, false, false, false)
	PlaceObjectOnGroundProperly(previewObj)
	cb('ok')
end)

-- Threads

AddEventHandler("RoJea_property:decorate:isDecorating", function(cb) cb(SelectedObj and peanut) end)

CreateThread(function()
	while true do
		Wait(7)
		if DecoMode then
			DisableAllControlActions(0)
			EnableControlAction(0, 32, true) -- W
			EnableControlAction(0, 33, true) -- S
			EnableControlAction(0, 245, true) -- T
			EnableControlAction(0, 21, true) -- Left Shift
			EnableControlAction(0, 19, true) -- Left Alt
			EnableControlAction(0, 288, true) -- F1
			EnableControlAction(0, 289, true) -- F2
			EnableControlAction(0, 170, true) -- F3
			EnableControlAction(0, 191, true) -- Enter
			EnableControlAction(0, 174, true) -- Left Arrow
			EnableControlAction(0, 175, true) -- Right Arrow
			EnableControlAction(0, 27, true) -- Up Arrow
			EnableControlAction(0, 173, true) -- Down Arrow
			EnableControlAction(0, 10, true) -- Page Up
			EnableControlAction(0, 11, true) -- Page Down
			EnableControlAction(0, 194, true) -- Backspace

			DisplayRadar(false)

			CheckRotationInput()
			CheckMovementInput()

    
			if SelectedObj and peanut then
				SetEntityDrawOutline(SelectedObj)
				SetEntityDrawOutlineColor(116, 189, 252, 100)
				DrawMarker(21, SelObjPos.x, SelObjPos.y, SelObjPos.z + 1.28, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.6, 0.6, 0.6, 28, 149, 255, 100, true, true, 2, false, false, false, false)
				if rotateActive then
					CheckObjRotationInput()
				else
					CheckObjMovementInput()
				end
				if IsControlJustReleased(0, 170) then -- F3
					rotateActive = not rotateActive
				end
				if IsControlJustReleased(0, 19) then -- Left Alt
					PlaceObjectOnGroundProperly(SelectedObj)
					local groundPos = GetEntityCoords(SelectedObj)
					SelObjPos = groundPos
				end
				if IsControlJustReleased(0, 191) then -- Enter
					SetNuiFocus(true, true)
					cursorEnabled = true
					if not isEdit then
						SendNUIMessage({
							type = 'buyOption',
						})
					else
						SetNuiFocus(false, false)
            --print('cursor off by enter')
						cursorEnabled = false
						SaveDecorations()
						SelectedObj = nil
						SelObjId = 0
						peanut = false
						isEdit = false
					end
				end
			else
				if IsControlJustPressed(0, 166) then -- F5
					if not cursorEnabled then
         
            SetNuiFocus(true, true)
            cursorEnabled = true
            justEnabled = true
            SetCursorLocation(0.5, 0.5)
            SetTimeout(500, function() justEnabled = false end)
          end
				end
			end
		end
	end
end)


CreateThread(function()
	while true do
		Wait(7)
		if DecoMode then
      if not ClosestHouse then
        DisableEditMode()
				closeDecorateUI()
				ESX.ShowNotification("Nebesate namo viduje!")
      else
        local camPos = GetCamCoord(MainCamera)
        local dist = #(camPos - Config.Properties[ClosestHouse].enter)
        if dist > 50.0 then
          DisableEditMode()
          closeDecorateUI()
          ESX.ShowNotification("Nebesate namo viduje!")
        end
      end
		end
	end
end)
