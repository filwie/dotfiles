#!/usr/bin/env bash
curl https://sh.rustup.rs -sSf | sh
rustup toolchain add nightly
rustup component add rust-src
cargo +nightly install racer
rustup completions fish > ~/.config/fish/completions/rustup.fish
