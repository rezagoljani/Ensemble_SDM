cd "D:\PICCC_analysis\code\Ensemble_SDM\project_config_files\test_config_runs\100runs\no_RF 100m"
::cd to directory where r code is located
::have the number of instances equal the number of CPU cores available
::add plenty of time between initiations to allow for instances to detect total number of running instances
START "" "C:\Program Files\R\R-3.0.1\bin\x64\R.exe" "test_runs_round5_100m_noRF__P_A_hiPAdens_5_100runs.r" /b
timeout 2
START "" "C:\Program Files\R\R-3.0.1\bin\x64\R.exe" test_runs_round5_100m_noRF__P_A_lowPAdens_0.5_100runs.r" /b
timeout 2
START "" "C:\Program Files\R\R-3.0.1\bin\x64\R.exe" "test_runs_round5_100m_noRF__P_A_medPAdens_1__100runs.r" /b
timeout 2
START "" "C:\Program Files\R\R-3.0.1\bin\x64\R.exe" "test_runs_round5_100m_noRF__P_hiPAdens_50_100runs.r" /b
timeout 2
START "" "C:\Program Files\R\R-3.0.1\bin\x64\R.exe" "test_runs_round5_100m_noRF__P_lowPAdens_500_100runs.r" /b
timeout 2
START "" "C:\Program Files\R\R-3.0.1\bin\x64\R.exe" "test_runs_round5_100m_noRF__P_medPAdens_100_100runs.r" /b
exit