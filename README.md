# move-started
```
wsl install rustc
https://sh.rustup.rs/
sh rustup-init.sh (需要关闭代理)

install move-cli
git clone https://github.com/move-language/move.git
./scripts/dev_setup.sh -ypt
cargo install --path language/tools/move-cli (在move文件夹下,安装move命令)
move --version
move new move-started
move sandbox publish
move sandbox run ./sources/my_script.move
aptos move test (执行项目中#[test]注解)
move sandbox run ./sources/my_script.move --args 10 (传入参数)
move sandbox run ./sources/my_script.move --signers 0xCD
```