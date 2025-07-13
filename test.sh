#!/bin/bash
#SBATCH -A <your_project_code>              # Replace with your allocation code (e.g., IscrC_AdvCMT)
#SBATCH -p boost_usr_prod                   # Partition with GPU access
#SBATCH --gres=gpu:a100:1                   # Request 1 A100 GPU
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
#SBATCH --job-name=your_job_name            # Name your job
#SBATCH --output=logs/job_output.out        # Log file path
#SBATCH --open-mode=truncate                # Overwrite old logs

echo "Starting job on node(s): $SLURM_NODELIST"

# Change to your working directory
cd /leonardo/home/userexternal/<your_username>/<your_project_folder>

# Prevent WANDB from trying to sync online
export WANDB_MODE=offline

# Load modules and activate Conda environment
module purge
module load cuda/11.8
module load anaconda3

# Initialize conda in the shell
source "$(dirname "$(which conda)")/../etc/profile.d/conda.sh"
conda activate <your_env_name>

# Show Python and GPU info (sanity checks)
PYTHON_BIN=$(conda run -n <your_env_name> which python)
echo "Using Python from: ${PYTHON_BIN}"
${PYTHON_BIN} -c "print('Sanity check — Python is working.')"
nvidia-smi

# Run your Python script
# Replace this command with your own script + arguments
srun ${PYTHON_BIN} your_script.py \
    --data_path your_data.jsonl \
    --model_path your_model_folder \
    --output_dir output_folder

echo "Job completed."
