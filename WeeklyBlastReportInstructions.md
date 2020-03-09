Weekly Blast Report

Background:

The purpose of this report is to recreate the month over month report for each player, showing a table of relevant statistics collected by Blast in a week over week format instead, as well as plots against the team average as well.
Week numbers are determiend via the ISO calendar, where Monday of each week constitutes the start of each week. This can be ammended, but was chosen as most college games are on the weekend. See link for 2020 week numbers: https://www.epochconverter.com/weeks/2020

Files Needed:

1) Single folder containing all individual Blast data files in .csv format
2) Download BlastViz_fullTeamScript.R
3) Download BlastMergingCleaning.R

Instructions for use:

1) Ensure there is a folder containing only relevant Blast data csv's for each player
2) Download RStudio
3) Open BlastViz_fullTeamScript.R file in Rstudio or R
    3a) First time only: Packages at top of file will need to be installed prior to running for the first time
4) Run BlastViz_fullTeamScript.R
5) A file window will open, choose the BlastMergingCleaning.R and continue
6) A second window will now open, choose the folder containing the Blast data and continue
7) In the terminal window in R/Rstudio, there will be a prompt to enter the week number. This will be the later of the 2 weeks used in the comparison
8) After this is done, there will be a 2 page PDF labeled player_week#.pdf saved off automatically

Potential Bugs:

1) If there is not data for the chosen week for a player, the script will throw an error and stop running. Simply deleting the issue file and re-running the script will fix this problem.
2) Only player data in csv form may be in the folder containing the wrong player data, any other type of file formats contained in the folder will cause errors until they are removed.

Future Improvements:

1) Output file formatting. Its very basic right now, but all requested tables/plots/metrics are included, as well as each page having the player name and week number listed for clarity.
2) Error stops. In the future it would be beneficial to add additional measures to bypass the need to have only correct files and formats in the data folder. If this was the case, we would be able to simply ignore files in the wrong format or not containing the correct weeks so that the process will still continue to generate correct outputs for the files that do npt have any issues.
