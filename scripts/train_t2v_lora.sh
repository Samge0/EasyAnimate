export MODEL_NAME="models/Diffusion_Transformer/PixArt-XL-2-512x512"
export DATASET_NAME="datasets/internal_datasets/"
export DATASET_META_NAME="datasets/internal_datasets/metadata.json"
export NCCL_IB_DISABLE=1
export NCCL_P2P_DISABLE=1
NCCL_DEBUG=INFO

# When train model with multi machines, use "--config_file accelerate.yaml" instead of "--mixed_precision='bf16'".
accelerate launch --mixed_precision="bf16" scripts/train_t2v_lora.py \
  --pretrained_model_name_or_path=$MODEL_NAME \
  --transformer_path="models/Motion_Module/easyanimate_v1_mm.safetensors" \
  --train_data_dir=$DATASET_NAME \
  --train_data_meta=$DATASET_META_NAME \
  --config_path "config/easyanimate_video_motion_module_v1.yaml" \
  --train_data_format="normal" \
  --train_mode="normal" \
  --sample_size=512 \
  --sample_stride=2 \
  --sample_n_frames=80 \
  --train_batch_size=1 \
  --gradient_accumulation_steps=1 \
  --dataloader_num_workers=8 \
  --num_train_epochs=100 \
  --checkpointing_steps=500 \
  --validation_prompts="A girl with delicate face is smiling." \
  --validation_epochs=1 \
  --validation_steps=100 \
  --learning_rate=2e-05 \
  --seed=42 \
  --output_dir="output_dir" \
  --enable_xformers_memory_efficient_attention \
  --gradient_checkpointing \
  --mixed_precision="bf16" \
  --adam_weight_decay=3e-2 \
  --adam_epsilon=1e-10 \
  --max_grad_norm=1 \
  --vae_mini_batch=16