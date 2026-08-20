DOTFILES := $(shell pwd)
LOCAL    := $(HOME)/.local
BIN      := $(LOCAL)/bin

# ── Detect arch ──────────────────────────────────────────────
ARCH     := $(shell uname -m)
OS       := $(shell uname -s)

# ── Versions ─────────────────────────────────────────────────
FASTFETCH_VER   := 2.67.1
TMUX_VER        := 3.7b

# ── Colors ───────────────────────────────────────────────────
GREEN  := \033[1;32m
YELLOW := \033[1;33m
RESET  := \033[0m

.PHONY: all zsh oh-my-zsh plugins p10k tmux tpm fastfetch cargo myx opencode link unlink move-cargo clean help

all: zsh oh-my-zsh plugins p10k tmux tpm fastfetch cargo myx opencode link move-cargo
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
	@if [ -d $(HOME)/.oh-my-zsh ]; then \
		echo "$(GREEN)  Oh My Zsh already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing Oh My Zsh...$(RESET)"; \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
		echo "$(GREEN)  Oh My Zsh ready$(RESET)"; \
	fi

# ── ZSH Plugins ─────────────────────────────────────────────
plugins: zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete

zsh-autosuggestions:
	@echo "$(YELLOW)→ Checking zsh-autosuggestions...$(RESET)"
	@if [ -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then \
		echo "$(GREEN)  zsh-autosuggestions already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing zsh-autosuggestions...$(RESET)"; \
		git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
		echo "$(GREEN)  ready$(RESET)"; \
	fi

zsh-syntax-highlighting:
	@echo "$(YELLOW)→ Checking zsh-syntax-highlighting...$(RESET)"
	@if [ -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then \
		echo "$(GREEN)  zsh-syntax-highlighting already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing zsh-syntax-highlighting...$(RESET)"; \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
		echo "$(GREEN)  ready$(RESET)"; \
	fi

zsh-autocomplete:
	@echo "$(YELLOW)→ Checking zsh-autocomplete...$(RESET)"
	@if [ -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autocomplete ]; then \
		echo "$(GREEN)  zsh-autocomplete already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing zsh-autocomplete...$(RESET)"; \
		git clone https://github.com/marlonrichert/zsh-autocomplete $(HOME)/.oh-my-zsh/custom/plugins/zsh-autocomplete; \
		echo "$(GREEN)  ready$(RESET)"; \
	fi

# ── Powerlevel10k ───────────────────────────────────────────
p10k:
	@echo "$(YELLOW)→ Checking Powerlevel10k...$(RESET)"
	@if [ -d $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k ]; then \
		echo "$(GREEN)  Powerlevel10k already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing Powerlevel10k...$(RESET)"; \
		git clone --depth=1 https://github.com/romkatv/powerlevel10k $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k; \
		echo "$(GREEN)  ready$(RESET)"; \
	fi

# ── TPM (tmux plugin manager) ───────────────────────────────
tpm:
	@echo "$(YELLOW)→ Checking TPM...$(RESET)"
	@if [ -d $(HOME)/.tmux/plugins/tpm ]; then \
		echo "$(GREEN)  TPM already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing TPM...$(RESET)"; \
		git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm; \
		echo "$(GREEN)  ready$(RESET)"; \
	fi

# ── fastfetch (pre-built binary to ~/.local) ────────────────
fastfetch:
	@echo "$(YELLOW)→ Checking fastfetch...$(RESET)"
	@if [ -x $(BIN)/fastfetch ]; then \
		echo "$(GREEN)  fastfetch already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing fastfetch $(FASTFETCH_VER)...$(RESET)"; \
		mkdir -p $(BIN); \
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
			rm -rf $$TMPDIR; \
		echo "$(GREEN)  fastfetch installed$(RESET)"; \
	fi

# ── tmux (pre-built static binary to ~/.local) ─────────────
tmux:
	@echo "$(YELLOW)→ Checking tmux...$(RESET)"
	@if [ -x $(BIN)/tmux ]; then \
		echo "$(GREEN)  tmux already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing tmux $(TMUX_VER)...$(RESET)"; \
		mkdir -p $(BIN); \
		TMPDIR=$$(mktemp -d) && \
			if [ "$(OS)" = "Linux" ]; then \
				if [ "$(ARCH)" = "aarch64" ]; then \
					FF_ARCH="arm64"; \
				else \
					FF_ARCH="x86_64"; \
				fi; \
				curl -fsSL "https://github.com/tmux/tmux-builds/releases/download/v$(TMUX_VER)/tmux-$(TMUX_VER)-linux-$$FF_ARCH.tar.gz" \
					-o $$TMPDIR/tmux.tar.gz && \
				tar xzf $$TMPDIR/tmux.tar.gz -C $$TMPDIR && \
				cp $$TMPDIR/tmux $(BIN)/tmux; \
			elif [ "$(OS)" = "Darwin" ]; then \
				if [ "$(ARCH)" = "arm64" ]; then \
					FF_ARCH="arm64"; \
				else \
					FF_ARCH="x86_64"; \
				fi; \
				curl -fsSL "https://github.com/tmux/tmux-builds/releases/download/v$(TMUX_VER)/tmux-$(TMUX_VER)-macos-$$FF_ARCH.tar.gz" \
					-o $$TMPDIR/tmux.tar.gz && \
				tar xzf $$TMPDIR/tmux.tar.gz -C $$TMPDIR && \
				cp $$TMPDIR/tmux $(BIN)/tmux; \
			fi && \
			chmod +x $(BIN)/tmux && \
			rm -rf $$TMPDIR; \
		echo "$(GREEN)  tmux installed$(RESET)"; \
	fi

# ── Rust / Cargo ────────────────────────────────────────────
CARGO_DIR := /goinfre/$(shell whoami)

cargo:
	@echo "$(YELLOW)→ Checking cargo...$(RESET)"
	@if [ -L $(HOME)/.cargo ] && [ ! -d $(HOME)/.cargo ]; then \
		echo "$(YELLOW)  Broken symlink detected — cleaning up$(RESET)"; \
		rm -f $(HOME)/.cargo $(HOME)/.rustup; \
	fi
	@if [ -x $(HOME)/.cargo/bin/cargo ]; then \
		echo "$(GREEN)  cargo found: $(HOME)/.cargo/bin/cargo$(RESET)"; \
	elif command -v cargo > /dev/null 2>&1; then \
		echo "$(GREEN)  cargo found: $$(which cargo)$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing Rust via rustup...$(RESET)"; \
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path; \
		echo "$(GREEN)  Rust installed$(RESET)"; \
	fi

# ── myx (via cargo) ─────────────────────────────────────────
myx: cargo
	@echo "$(YELLOW)→ Checking myx...$(RESET)"
	@if [ -x $(HOME)/.cargo/bin/myx ] || command -v myx > /dev/null 2>&1; then \
		echo "$(GREEN)  myx already installed$(RESET)"; \
	else \
		MISSING=""; \
		if ! command -v pkg-config > /dev/null 2>&1; then MISSING="pkg-config "; fi; \
		if ! dpkg -s libssl-dev > /dev/null 2>&1; then MISSING="$$MISSING libssl-dev "; fi; \
		if ! dpkg -s libasound2-dev > /dev/null 2>&1; then MISSING="$$MISSING libasound2-dev"; fi; \
		if [ -n "$$MISSING" ]; then \
			echo "$(YELLOW)  myx requires: $$MISSING$(RESET)"; \
			printf "$(YELLOW)  Install with sudo? [y/N] $(RESET)"; \
			read REPLY; \
			if [ "$$REPLY" = "y" ] || [ "$$REPLY" = "Y" ]; then \
				sudo apt install -y $$MISSING; \
			else \
				echo "$(YELLOW)  Skipping myx$(RESET)"; \
				exit 0; \
			fi; \
		fi; \
		echo "$(YELLOW)  Installing myx...$(RESET)"; \
		if [ -x $(HOME)/.cargo/bin/cargo ]; then \
			$(HOME)/.cargo/bin/cargo install myx || { echo "$(YELLOW)  myx build failed$(RESET)"; exit 1; }; \
		elif command -v cargo > /dev/null 2>&1; then \
			cargo install myx || { echo "$(YELLOW)  myx build failed$(RESET)"; exit 1; }; \
		else \
			echo "$(YELLOW)  cargo not found — run 'source ~/.cargo/env' or restart shell$(RESET)"; \
			exit 1; \
		fi; \
		echo "$(GREEN)  myx ready$(RESET)"; \
	fi

# ── Move cargo to goinfre (runs last) ───────────────────────
move-cargo:
	@echo "$(YELLOW)→ Moving cargo/rustup to goinfre...$(RESET)"
	@if [ ! -d /goinfre ]; then \
		echo "$(YELLOW)  /goinfre not found — skipping$(RESET)"; \
	elif [ ! -L $(HOME)/.cargo ] && [ -d $(HOME)/.cargo ]; then \
		mkdir -p $(CARGO_DIR); \
		mv $(HOME)/.cargo $(CARGO_DIR)/; \
		mv $(HOME)/.rustup $(CARGO_DIR)/ 2>/dev/null || true; \
		ln -s $(CARGO_DIR)/.cargo $(HOME)/.cargo; \
		ln -s $(CARGO_DIR)/.rustup $(HOME)/.rustup; \
		echo "$(GREEN)  Moved to goinfre with symlinks$(RESET)"; \
	else \
		echo "$(GREEN)  cargo already in goinfre or symlinked$(RESET)"; \
	fi

# ── opencode ────────────────────────────────────────────────
opencode:
	@echo "$(YELLOW)→ Checking opencode...$(RESET)"
	@if [ -x $(HOME)/.opencode/bin/opencode ] || command -v opencode > /dev/null 2>&1; then \
		echo "$(GREEN)  opencode already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Installing opencode...$(RESET)"; \
		curl -fsSL https://opencode.ai/install | bash; \
		echo "$(GREEN)  opencode ready$(RESET)"; \
	fi

# ── Symlink dotfiles ────────────────────────────────────────
link:
	@echo "$(YELLOW)→ Linking dotfiles...$(RESET)"
	@LINKED=0; \
	if [ "$(readlink $(HOME)/.zshrc 2>/dev/null)" = "$(DOTFILES)/.zshrc" ]; then \
		echo "$(GREEN)  .zshrc already linked$(RESET)"; \
	else \
		ln -sf $(DOTFILES)/.zshrc $(HOME)/.zshrc; LINKED=1; \
	fi; \
	if [ "$(readlink $(HOME)/.p10k.zsh 2>/dev/null)" = "$(DOTFILES)/.p10k.zsh" ]; then \
		echo "$(GREEN)  .p10k.zsh already linked$(RESET)"; \
	else \
		ln -sf $(DOTFILES)/.p10k.zsh $(HOME)/.p10k.zsh; LINKED=1; \
	fi; \
	if [ "$(readlink $(HOME)/.tmux.conf 2>/dev/null)" = "$(DOTFILES)/.tmux.conf" ]; then \
		echo "$(GREEN)  .tmux.conf already linked$(RESET)"; \
	else \
		ln -sf $(DOTFILES)/.tmux.conf $(HOME)/.tmux.conf; LINKED=1; \
	fi; \
	mkdir -p $(HOME)/.config/fastfetch; \
	if [ "$(readlink $(HOME)/.config/fastfetch/config.jsonc 2>/dev/null)" = "$(DOTFILES)/fastfetch/config.jsonc" ]; then \
		echo "$(GREEN)  fastfetch/config.jsonc already linked$(RESET)"; \
	else \
		ln -sf $(DOTFILES)/fastfetch/config.jsonc $(HOME)/.config/fastfetch/config.jsonc; LINKED=1; \
	fi; \
	if [ "$(readlink $(HOME)/.config/fastfetch/config.alt.jsonc 2>/dev/null)" = "$(DOTFILES)/fastfetch/config.alt.jsonc" ]; then \
		echo "$(GREEN)  fastfetch/config.alt.jsonc already linked$(RESET)"; \
	else \
		ln -sf $(DOTFILES)/fastfetch/config.alt.jsonc $(HOME)/.config/fastfetch/config.alt.jsonc; LINKED=1; \
	fi; \
	mkdir -p $(HOME)/.config/myx; \
	if [ "$(readlink $(HOME)/.config/myx/config.toml 2>/dev/null)" = "$(DOTFILES)/myx/config.toml" ]; then \
		echo "$(GREEN)  myx/config.toml already linked$(RESET)"; \
	else \
		ln -sf $(DOTFILES)/myx/config.toml $(HOME)/.config/myx/config.toml; LINKED=1; \
	fi; \
	mkdir -p $(HOME)/.config/opencode; \
	if [ "$(readlink $(HOME)/.config/opencode/opencode.jsonc 2>/dev/null)" = "$(DOTFILES)/opencode/opencode.jsonc" ]; then \
		echo "$(GREEN)  opencode/opencode.jsonc already linked$(RESET)"; \
	else \
		ln -sf $(DOTFILES)/opencode/opencode.jsonc $(HOME)/.config/opencode/opencode.jsonc; LINKED=1; \
	fi; \
	mkdir -p $(BIN); \
	if [ "$$LINKED" = "0" ]; then \
		echo "$(GREEN)  All symlinks already correct$(RESET)"; \
	else \
		echo "$(GREEN)  Symlinks updated$(RESET)"; \
	fi

# ── Remove symlinks ─────────────────────────────────────────
unlink:
	@echo "$(YELLOW)→ Removing symlinks...$(RESET)"
	@rm -f $(HOME)/.zshrc $(HOME)/.p10k.zsh $(HOME)/.tmux.conf
	@rm -f $(HOME)/.config/fastfetch/config.jsonc $(HOME)/.config/fastfetch/config.alt.jsonc
	@rm -f $(HOME)/.config/myx/config.toml
	@rm -f $(HOME)/.config/opencode/opencode.jsonc
	@echo "$(GREEN)  Symlinks removed$(RESET)"

# ── Clean stale files ────────────────────────────────────────
clean:
	@echo "$(YELLOW)→ Cleaning stale files...$(RESET)"
	@rm -f $(HOME)/.zshrc.pre-oh-my-zsh*
	@rm -f $(HOME)/.zcompdump*
	@rm -f $(HOME)/.zshrc~
	@rm -rf /tmp/cargo-install*
	@echo "$(GREEN)  Cleaned$(RESET)"

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
	@echo "  tmux       Install tmux binary"
	@echo "  tpm        Install tmux plugin manager"
	@echo "  fastfetch  Install fastfetch binary"
	@echo "  cargo      Install Rust toolchain"
	@echo "  myx        Install myx via cargo"
	@echo "  opencode   Install opencode"
	@echo "  link       Symlink all config files to ~"
	@echo "  unlink     Remove symlinks"
	@echo "  move-cargo Move cargo/rustup to goinfre"
	@echo "  clean      Remove stale files"
