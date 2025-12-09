while :; do
    clear
    echo "═══ $(date '+%Y-%m-%d %H:%M:%S') ═════════════════════════════════════════"
    nvidia-smi --query-gpu=name,memory.total,memory.used,memory.free,utilization.gpu,temperature.gpu --format=csv,noheader,nounits
    echo
    echo "Top VRAM processes (PID → command)"
    nvidia-smi pmon -s m -o DTPMC | grep -v "No running" | head -20 || echo "  (none)"
    sleep 1
done
