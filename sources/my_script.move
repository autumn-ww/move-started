script {
    use std::debug;
    use std::signer;
    use move_dao::my_module;

    fun main(account: signer) {
        // assert!(my_module::is_even(_x), 0);
        let r = signer::address_of(&account);
        debug::print(&r);
        debug::print(&account);
        debug::print(&my_module::speak());
    }
}