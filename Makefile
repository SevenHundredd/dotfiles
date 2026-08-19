DOTFILES := $(shell pwd)
LOCAL    := $(HOME)/.local
BIN      := $(LOCAL)/bin

# ── Detect arch ──────────────────────────────────────────────
ARCH     := $(shell uname -m)
OS       := $(shell uname -s)

# ── Versions ─────────────────────────────────────────────────
FASTFETCH_VER   := 2.67.1

# ── Colors ───────────────────────────────────────────────────
GREEN  := \033[1;32m
YELLOW := \033[1;33m
RESET  := \033[0m

.PHONY: all zsh oh-my-zsh plugins p10k tpm fastfetch cargo myx opencode link unlink help

all: zsh oh-my-zsh plugins p10k tpm fastfetch cargo myx opencode link
	@echo "$(GREEN)✔ Setup complete.$(RESET)"

# ── ZSH ──────────────────────────────────────────────────────
zsh:
	@echo "$(YELLOW)→ Checking zsh...$(RESET)"
	@if which zsh > /dev/null 2>&1; then \
		echo "$(GREEN)  zsh found: $$(which zsh)$(RESET)"; \
	else \
		echo "$(YELLOW)  zsh not found — install it manually$(RESET)"; \
	fi

# ── Oh My Zsh ────────────────────────────────────────────────
oh-my-zsh:
	@echo "$(YELLOW)→ Checking Oh My Zsh...$(RESET)"
	@test -d $(HOME)/.oh-my-zsh && echo "$(GREEN)  Oh My Zsh already installed$(RESET)" || \
		(sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
		echo "$(GREEN)  Oh My Zsh ready$(RESET)")

# ── ZSH Plugins ─────────────────────────────────────────────
plugins: zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete

zsh-autosuggestions:
	@echo "$(YELLOW)→ Checking zsh-autosuggestions...$(RESET)"
	@test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions && echo "$(GREEN)  already installed$(RESET)" || \
		(git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
		echo "$(GREEN)  ready$(RESET)")

zsh-syntax-highlighting:
	@echo "$(YELLOW)→ Checking zsh-syntax-highlighting...$(RESET)"
	@test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && echo "$(GREEN)  already installed$(RESET)" || \
		(git clone https://github.com/zsh-users/zsh-syntax-highlighting $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
		echo "$(GREEN)  ready$(RESET)")

zsh-autocomplete:
	@echo "$(YELLOW)→ Checking zsh-autocomplete...$(RESET)"
	@test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autocomplete && echo "$(GREEN)  already installed$(RESET)" || \
		(git clone https://github.com/marlonrichert/zsh-autocomplete $(HOME)/.oh-my-zsh/custom/plugins/zsh-autocomplete && \
		echo "$(GREEN)  ready$(RESET)")

# ── Powerlevel10k ───────────────────────────────────────────
p10k:
	@echo "$(YELLOW)→ Checking Powerlevel10k...$(RESET)"
	@test -d $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k && echo "$(GREEN)  already installed$(RESET)" || \
		(git clone --depth=1 https://github.com/romkatv/powerlevel10k $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k && \
		echo "$(GREEN)  ready$(RESET)")

# ── TPM (tmux plugin manager) ───────────────────────────────
tpm:
	@echo "$(YELLOW)→ Checking TPM...$(RESET)"
	@test -d $(HOME)/.tmux/plugins/tpm && echo "$(GREEN)  already installed$(RESET)" || \
		(git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm && \
		echo "$(GREEN)  ready$(RESET)")

# ── fastfetch (pre-built binary to ~/.local) ────────────────
fastfetch:
	@echo "$(YELLOW)→ Checking fastfetch...$(RESET)"
	@if which fastfetch > /dev/null 2>&1; then \
		echo "$(GREEN)  fastfetch found: $$(which fastfetch)$(RESET)"; \
	else \
		echo "$(YELLOW)  Downloading fastfetch $(FASTFETCH_VER)...$(RESET)"; \
		mkdir -p $(BIN) && \
		TMPDIR=$$(mktemp -d) && \
		if [ "$(OS)" = "Linux" ]; then \
			curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/$(FASTFETCH_VER)/fastfetch-linux-amd64.tar.gz" \
				-o $$TMPDIR/ff.tar.gz && \
			tar xzf $$TMPDIR/ff.tar.gz -C $$TMPDIR && \
			cp $$TMPDIR/fastfetch-linux-amd64/usr/bin/fastfetch $(BIN)/fastfetch; \
		elif [ "$(OS)" = "Darwin" ]; then \
			curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/$(FASTFETCH_VER)/fastfetch-macos-amd64.tar.gz" \
				-o $$TMPDIR/ff.tar.gz && \
			tar xzf $$TMPDIR/ff.tar.gz -C $$TMPDIR && \
			cp $$TMPDIR/fastfetch-macos-amd64/usr/bin/fastfetch $(BIN)/fastfetch; \
		fi && \
		chmod +x $(BIN)/fastfetch && \
		rm -rf $$TMPDIR && \
		echo "$(GREEN)  fastfetch installed to $(BIN)$(RESET)"; \
	fi

# ── Rust / Cargo ────────────────────────────────────────────
cargo:
	@echo "$(YELLOW)→ Checking cargo...$(RESET)"
	@if which cargo > /dev/null 2>&1; then \
		echo "$(GREEN)  cargo found: $$(which cargo)$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing Rust via rustup...$(RESET)"; \
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path; \
		echo "$(GREEN)  Rust installed — run '$(HOME)/.cargo/env' or restart shell$(RESET)"; \
	fi

# ── myx (via cargo) ─────────────────────────────────────────
myx:
	@echo "$(YELLOW)→ Checking myx...$(RESET)"
	@if which myx > /dev/null 2>&1; then \
		echo "$(GREEN)  myx found: $$(which myx)$(RESET)"; \
	else \
		. $(HOME)/.cargo/env 2>/dev/null && cargo install myx && echo "$(GREEN)  myx ready$(RESET)" || \
		echo "$(YELLOW)  myx install skipped$(RESET)"; \
	fi

# ── opencode ────────────────────────────────────────────────
opencode:
	@echo "$(YELLOW)→ Checking opencode...$(RESET)"
	@test -x $(HOME)/.opencode/bin/opencode && echo "$(GREEN)  opencode already installed$(RESET)" || \
		(mkdir -p $(HOME)/.opencode/bin && \
		curl -fsSL https://opencode.ai/install.sh | bash -s -- --dir $(HOME)/.opencode/bin 2>/dev/null && \
		echo "$(GREEN)  opencode ready$(RESET)") || \
		echo "$(YELLOW)  opencode install skipped$(RESET)"

# ── Symlink dotfiles ────────────────────────────────────────
link:
	@echo "$(YELLOW)→ Linking dotfiles...$(RESET)"
	@ln -sf $(DOTFILES)/.zshrc      $(HOME)/.zshrc
	@ln -sf $(DOTFILES)/.p10k.zsh   $(HOME)/.p10k.zsh
	@ln -sf $(DOTFILES)/.tmux.conf  $(HOME)/.tmux.conf
	@mkdir -p $(HOME)/.config/fastfetch
	@ln -sf $(DOTFILES)/fastfetch/config.jsonc     $(HOME)/.config/fastfetch/config.jsonc
	@ln -sf $(DOTFILES)/fastfetch/config.alt.jsonc $(HOME)/.config/fastfetch/config.alt.jsonc
	@mkdir -p $(HOME)/.config/myx
	@ln -sf $(DOTFILES)/myx/config.toml $(HOME)/.config/myx/config.toml
	@mkdir -p $(HOME)/.config/opencode
	@ln -sf $(DOTFILES)/opencode/opencode.jsonc $(HOME)/.config/opencode/opencode.jsonc
	@mkdir -p $(BIN)
	@echo "$(GREEN)  Symlinks created$(RESET)"

# ── Remove symlinks ─────────────────────────────────────────
unlink:
	@echo "$(YELLOW)→ Removing symlinks...$(RESET)"
	@rm -f $(HOME)/.zshrc $(HOME)/.p10k.zsh $(HOME)/.tmux.conf
	@rm -f $(HOME)/.config/fastfetch/config.jsonc $(HOME)/.config/fastfetch/config.alt.jsonc
	@rm -f $(HOME)/.config/myx/config.toml
	@rm -f $(HOME)/.config/opencode/opencode.jsonc
	@echo "$(GREEN)  Symlinks removed$(RESET)"

# ── Help ────────────────────────────────────────────────────
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all        Install everything (default)"
	@echo "  zsh        Check zsh is installed"
	@echo "  oh-my-zsh  Install Oh My Zsh"
	@echo "  plugins    Install zsh plugins"
	@echo "  p10k       Install Powerlevel10k"
	@echo "  tpm        Install tmux plugin manager"
	@echo "  fastfetch  Install fastfetch binary"
	@echo "  cargo      Install Rust toolchain"
	@echo "  myx        Install myx via cargo"
	@echo "  opencode   Install opencode"
	@echo "  link       Symlink all config files to ~"
	@echo "  unlink     Remove symlinks"
