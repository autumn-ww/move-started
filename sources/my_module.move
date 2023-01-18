module move_dao::my_module {
    use std::string;
    use std::debug;

    public fun speak(): string::String {
        string::utf8(b"Hello World")
    }

    #[test]
    public fun test_speak() {
        let res = speak();

        debug::print(&res);

        let except = string::utf8(b"Hello World");
        assert!(res == except, 0);
    }
   
    struct Example has drop{
        i: u64
    }

    const ENOT_POSITIVE_NUMBER: u64 = 0;
    
    public fun is_even(x: u64): bool {  
        let example = Example { i: x };
        if(example.i % 2 == 0){
            true
        }else{
            false
        }
    }
}