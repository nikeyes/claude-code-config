echo "Test con 70% (rojo, CON warning):" && echo '{
        "model": {"display_name": "Sonnet 4.5"},
        "context_window": {
          "context_window_size": 200000,
          "current_usage": {
            "input_tokens": 70000,
            "output_tokens": 70000,
            "cache_creation_input_tokens": 0,
            "cache_read_input_tokens": 0
          }
        }
      }' | ~/.claude/statusline.sh