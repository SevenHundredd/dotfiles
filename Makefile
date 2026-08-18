DOTFILES := $(shell pwd)
LOCAL    := $(HOME)/.local
BIN      := $(LOCAL)/bin

# ── Detect arch ──────────────────────────────────────────────
ARCH     := $(shell uname -m)
OS       := $(shell uname -s)

# ── Versions ─────────────────────────────────────────────────
TMUX_VERSION    := 3.7
FASTFETCH_VER   := 2.67.1

# ── Colors ───────────────────────────────────────────────────
GREEN  := \033[1;32m
YELLOW := \033[1;33m
RESET  := \033[0m

.PHONY: all zsh oh-my-zsh plugins p10k tmux libevent ncurses tpm fastfetch cargo myx opencode link unlink help

all: zsh oh-my-zsh plugins p10k tmux fastfetch cargo myx opencode link
	@echo "$(GREEN)✔ Setup complete.$(RESET)"

# ── ZSH ──────────────────────────────────────────────────────
HAS_ZSH := $(shell which zsh > /dev/null 2>&1 && echo 1 || echo 0)

zsh:
	@echo "$(YELLOW)→ Checking zsh...$(RESET)"
	@if [ "$(HAS_ZSH)" = "1" ]; then \
		echo "$(GREEN)  zsh found: $$(which zsh)$(RESET)"; \
	else \
		echo "$(YELLOW)  zsh not found — install it manually before using the shell$(RESET)"; \
	fi

# ── Oh My Zsh ────────────────────────────────────────────────
oh-my-zsh: zsh
	@echo "$(YELLOW)→ Installing Oh My Zsh...$(RESET)"
	@if [ "$(HAS_ZSH)" = "0" ]; then \
		echo "$(YELLOW)  skipping — zsh not installed$(RESET)"; \
	elif test -d $(HOME)/.oh-my-zsh; then \
		echo "$(GREEN)  Oh My Zsh already installed$(RESET)"; \
	else \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
		echo "$(GREEN)  Oh My Zsh ready$(RESET)"; \
	fi

# ── ZSH Plugins ─────────────────────────────────────────────
plugins: zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete

zsh-autosuggestions: oh-my-zsh
	@echo "$(YELLOW)→ Installing zsh-autosuggestions...$(RESET)"
	@if test -d $(HOME)/.oh-my-zsh; then \
		test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions || \
			git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	else \
		echo "$(YELLOW)  skipping — Oh My Zsh not installed$(RESET)"; \
	fi

zsh-syntax-highlighting: oh-my-zsh
	@echo "$(YELLOW)→ Installing zsh-syntax-highlighting...$(RESET)"
	@if test -d $(HOME)/.oh-my-zsh; then \
		test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || \
			git clone https://github.com/zsh-users/zsh-syntax-highlighting $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
	else \
		echo "$(YELLOW)  skipping — Oh My Zsh not installed$(RESET)"; \
	fi

zsh-autocomplete: oh-my-zsh
	@echo "$(YELLOW)→ Installing zsh-autocomplete...$(RESET)"
	@if test -d $(HOME)/.oh-my-zsh; then \
		test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autocomplete || \
			git clone https://github.com/marlonrichert/zsh-autocomplete $(HOME)/.oh-my-zsh/custom/plugins/zsh-autocomplete; \
	else \
		echo "$(YELLOW)  skipping — Oh My Zsh not installed$(RESET)"; \
	fi

# ── Powerlevel10k ───────────────────────────────────────────
p10k: oh-my-zsh
	@echo "$(YELLOW)→ Installing Powerlevel10k...$(RESET)"
	@if test -d $(HOME)/.oh-my-zsh; then \
		test -d $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k || \
			git clone --depth=1 https://github.com/romkatv/powerlevel10k $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k; \
		echo "$(GREEN)  Powerlevel10k ready$(RESET)"; \
	else \
		echo "$(YELLOW)  skipping — Oh My Zsh not installed$(RESET)"; \
	fi

# ── tmux (compiled from source, no sudo) ────────────────────
tmux: libevent ncurses
	@echo "$(YELLOW)→ Checking tmux...$(RESET)"
	@if which tmux > /dev/null 2>&1 && [ "$$(tmux -V)" = "tmux $(TMUX_VERSION)" ]; then \
		echo "$(GREEN)  tmux $(TMUX_VERSION) already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Building tmux $(TMUX_VERSION) from source...$(RESET)"; \
		TMPDIR=$$(mktemp -d) && \
		curl -fsSL https://github.com/tmux/tmux/releases/download/$(TMUX_VERSION)/tmux-$(TMUX_VERSION).tar.gz | tar xz -C $$TMPDIR && \
		cd $$TMPDIR/tmux-$(TMUX_VERSION) && \
		./configure --prefix=$(LOCAL) CFLAGS="-I$(LOCAL)/include" LDFLAGS="-L$(LOCAL)/lib -Wl,-rpath,$(LOCAL)/lib" 2>/dev/null && \
		make -j$$(nproc) && \
		make install 2>/dev/null && \
		cd $(HOME) && rm -rf $$TMPDIR && \
		echo "$(GREEN)  tmux $(TMUX_VERSION) installed to $(BIN)$(RESET)"; \
	fi

# ── libevent (for tmux, no sudo) ────────────────────────────
LIBEVENT_VER := 2.1.12
libevent:
	@if test -f $(LOCAL)/lib/libevent.so; then \
		echo "$(GREEN)  libevent already built$(RESET)"; \
	else \
		echo "$(YELLOW)  Building libevent $(LIBEVENT_VER)...$(RESET)"; \
		TMPDIR=$$(mktemp -d) && \
		curl -fsSL https://github.com/libevent/libevent/releases/download/release-$(LIBEVENT_VER)-stable/libevent-$(LIBEVENT_VER)-stable.tar.gz | tar xz -C $$TMPDIR && \
		cd $$TMPDIR/libevent-$(LIBEVENT_VER)-stable && \
		./configure --prefix=$(LOCAL) --disable-static --enable-shared 2>/dev/null && \
		make -j$$(nproc) && \
		make install-libLTLIBRARIES install-includeHEADERS install-include_event2HEADERS install-nodist_include_event2HEADERS install-pkgconfigDATA 2>/dev/null && \
		cd $(HOME) && rm -rf $$TMPDIR && \
		echo "$(GREEN)  libevent ready$(RESET)"; \
	fi

# ── ncurses (for tmux, no sudo) ─────────────────────────────
NCURSES_VER := 6.4
ncurses:
	@if test -f $(LOCAL)/lib/libncurses.so; then \
		echo "$(GREEN)  ncurses already built$(RESET)"; \
	else \
		echo "$(YELLOW)  Building ncurses $(NCURSES_VER)...$(RESET)"; \
		TMPDIR=$$(mktemp -d) && \
		curl -fsSL https://ftp.gnu.org/gnu/ncurses/ncurses-$(NCURSES_VER).tar.gz | tar xz -C $$TMPDIR && \
		cd $$TMPDIR/ncurses-$(NCURSES_VER) && \
		./configure --prefix=$(LOCAL) --with-shared --with-termlib --enable-pc-files 2>/dev/null && \
		make -j$$(nproc) && \
		make install.libs install.includes 2>/dev/null && \
		cp -f $(LOCAL)/include/ncurses/*.h $(LOCAL)/include/ 2>/dev/null; \
		cd $(HOME) && rm -rf $$TMPDIR && \
		echo "$(GREEN)  ncurses ready$(RESET)"; \
	fi

# ── TPM (tmux plugin manager) ───────────────────────────────
tpm:
	@echo "$(YELLOW)→ Installing TPM...$(RESET)"
	@test -d $(HOME)/.tmux/plugins/tpm || \
		git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm
	@echo "$(GREEN)  TPM ready — run prefix + I inside tmux to install plugins$(RESET)"

# ── fastfetch (pre-built binary) ────────────────────────────
fastfetch:
	@echo "$(YELLOW)→ Checking fastfetch...$(RESET)"
	@if which fastfetch > /dev/null 2>&1 && [ "$$(fastfetch --version 2>&1 | head -1)" = "fastfetch $(FASTFETCH_VER)" ]; then \
		echo "$(GREEN)  fastfetch $(FASTFETCH_VER) already installed$(RESET)"; \
	else \
		echo "$(YELLOW)  Downloading fastfetch $(FASTFETCH_VER)...$(RESET)"; \
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
myx: cargo
	@echo "$(YELLOW)→ Installing myx...$(RESET)"
	@. $(HOME)/.cargo/env && cargo install myx 2>/dev/null || echo "$(GREEN)  myx already installed$(RESET)"
	@echo "$(GREEN)  myx ready$(RESET)"

# ── opencode ────────────────────────────────────────────────
opencode:
	@echo "$(YELLOW)→ Installing opencode...$(RESET)"
	@test -x $(HOME)/.opencode/bin/opencode || \
		(mkdir -p $(HOME)/.opencode/bin && \
		curl -fsSL https://opencode.ai/install.sh | bash -s -- --dir $(HOME)/.opencode/bin 2>/dev/null) || \
		echo "  opencode install skipped (manual install may be needed)"
	@echo "$(GREEN)  opencode ready$(RESET)"

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
	@echo "  tmux       Build tmux from source (no sudo)"
	@echo "  tpm        Install tmux plugin manager"
	@echo "  fastfetch  Install fastfetch binary"
	@echo "  cargo      Install Rust toolchain"
	@echo "  myx        Install myx via cargo"
	@echo "  opencode   Install opencode"
	@echo "  link       Symlink all config files to ~"
	@echo "  unlink     Remove symlinks"
