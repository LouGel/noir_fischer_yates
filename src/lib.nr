use dep::std::hash::keccak256;

global DECK_SIZE: u32 = 52;

pub fn shuffle_size_256(arr: [u8; 256], length: u32, seed: [u8; 32]) -> [u8; 256] {
    let mut result = arr;

    let mut prng_state = seed;

    for i in 1..length {
        let index = length - i;

        prng_state = secure_prng_update(prng_state);

        let random_value = extract_u32_from_bytes(prng_state);

        let j = random_value % (index + 1);

        let temp = result[index];
        result[index] = result[j];
        result[j] = temp;
    }
    result
}
pub fn shuffle_size_1024(arr: [u8; 1024], length: u32, seed: [u8; 32]) -> [u8; 1024] {
    let mut result = arr;

    let mut prng_state = seed;

    for i in 1..length {
        let index = length - i;

        prng_state = secure_prng_update(prng_state);

        let random_value = extract_u32_from_bytes(prng_state);

        let j = random_value % (index + 1);

        let temp = result[index];
        result[index] = result[j];
        result[j] = temp;
    }
    result
}
pub fn shuffle_size_65536(arr: [u8; 65536], length: u32, seed: [u8; 32]) -> [u8; 65536] {
    let mut result = arr;

    let mut prng_state = seed;

    for i in 1..length {
        let index = length - i;

        prng_state = secure_prng_update(prng_state);

        let random_value = extract_u32_from_bytes(prng_state);

        let j = random_value % (index + 1);

        let temp = result[index];
        result[index] = result[j];
        result[j] = temp;
    }
    result
}

pub fn shuffle_deck(arr: [u8; DECK_SIZE], seed: [u8; 32]) -> [u8; DECK_SIZE] {
    let mut result = arr;

    let mut prng_state = seed;

    for i in 1..DECK_SIZE {
        let index = DECK_SIZE - i;

        prng_state = secure_prng_update(prng_state);

        let random_value = extract_u32_from_bytes(prng_state);

        let j = random_value % (index + 1);

        let temp = result[index];
        result[index] = result[j];
        result[j] = temp;
    }

    result
}

fn secure_prng_update(state: [u8; 32]) -> [u8; 32] {
    keccak256(state, 32)
}

fn extract_u32_from_bytes(bytes: [u8; 32]) -> u32 {
    let mut result: u32 = 0;

    result = (bytes[0] as u32) << 24
        | (bytes[1] as u32) << 16
        | (bytes[2] as u32) << 8
        | (bytes[3] as u32);

    result
}

#[test]
fn test_shuffle_deterministic() {
    let deck = [
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x10, 0x11,
        0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x20, 0x21, 0x22, 0x23,
        0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35,
        0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c,
    ];

    let mut seed1: [u8; 32] = [0; 32];
    seed1[0] = 0x12;
    seed1[1] = 0x34;
    seed1[2] = 0x56;
    seed1[3] = 0x78;

    let mut seed2: [u8; 32] = [0; 32];
    seed2[0] = 0x12;
    seed2[1] = 0x34;
    seed2[2] = 0x56;
    seed2[3] = 0x78;

    let shuffled1 = shuffle_deck(deck, seed1);
    let shuffled2 = shuffle_deck(deck, seed2);

    assert(shuffled1 == shuffled2);

    println(shuffled1);
}

#[test]
fn test_shuffle_different_seeds() {
    let deck = [
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x10, 0x11,
        0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x20, 0x21, 0x22, 0x23,
        0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35,
        0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c,
    ];

    let mut seed1: [u8; 32] = [0; 32];
    seed1[0] = 0x12;
    seed1[1] = 0x34;
    seed1[2] = 0x56;
    seed1[3] = 0x78;

    let mut seed2: [u8; 32] = [0; 32];
    seed2[0] = 0x11;
    seed2[1] = 0x34;
    seed2[2] = 0x56;
    seed2[3] = 0x78;

    let shuffled1 = shuffle_deck(deck, seed1);
    let shuffled2 = shuffle_deck(deck, seed2);

    assert(shuffled1 != shuffled2);

    println(shuffled1);
    println(shuffled2);
}

#[test]
fn test_multiple_shuffles_different() {
    let deck = [
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x10, 0x11,
        0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x20, 0x21, 0x22, 0x23,
        0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35,
        0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c,
    ];

    let mut seeds: [[u8; 32]; 5] = [[0; 32]; 5];

    for i in 0..5 {
        seeds[i][0] = (i as u8) + 1;
        seeds[i][1] = 0x34;
        seeds[i][2] = 0x56;
        seeds[i][3] = 0x78;
    }

    let mut shuffled_decks: [[u8; 52]; 5] = [[0; 52]; 5];

    for i in 0..5 {
        shuffled_decks[i] = shuffle_deck(deck, seeds[i]);
    }

    for i in 0..5 {
        for j in i + 1..5 {
            assert(shuffled_decks[i] != shuffled_decks[j]);
        }
    }

    println(shuffled_decks[0]);
}

#[test]
fn test_shuffle_preserves_cards() {
    let deck = [
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x10, 0x11,
        0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x20, 0x21, 0x22, 0x23,
        0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35,
        0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c,
    ];

    let mut seed: [u8; 32] = [0; 32];
    seed[0] = 0x12;
    seed[1] = 0x34;
    seed[2] = 0x56;
    seed[3] = 0x78;

    let shuffled = shuffle_deck(deck, seed);

    let mut found = [false; 52];
    for i in 0..52 {
        let card = shuffled[i];
        for j in 0..52 {
            if deck[j] == card {
                found[j] = true;
            }
        }
    }

    for i in 0..52 {
        assert(found[i]);
    }

    for i in 0..52 {
        let mut count = 0;
        for j in 0..52 {
            if shuffled[i] == shuffled[j] {
                count += 1;
            }
        }
        assert(count == 1);
    }

    println(shuffled);
}
