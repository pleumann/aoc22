org 32768

ld hl,message
ld 
    int findMarkerImproved(String s, int count) {
        int[] letters = new int[26];
        int unique = 0;

        for (int i = 0; i < s.length(); i++) {
            if (i >= count) {
                int c = s.charAt(i - count) - 'a';
                if (letters[c] > 0) {
                    letters[c]--;
                    if (letters[c] == 0) {
                        unique--;
                    }
                }
            }

            int c = s.charAt(i) - 'a';
            letters[c]++;
            if (letters[c] == 1) {
                unique++;
            }

    ld  hl,letters
    ld  e,(ix)
    add hl,de
    ld  a,(hl)
    inc a
    cp  1
    jr  nz,not_one
    dec c
not_one:
    ld  (hl),a

    inc ix
    ld  a,b
    cp  c
    jr  nz,loop

    ld  de,message
    and a
    sbc ix,de
    ld  bc,de
    ret

letters:
    ds 26

message:
    defm "hjchjcjhjshjsssrfsrrldrddbrrzfzjzzrffvwwclwlffhwhwpwfffcbctbccchmccfmmwdmmdwwdttwffsfshswhhfchfchcphpnnflnlznlnnnvpnnhjhrrjgrglgwwrgghzhnzztlltbtwbbvmmzppdmmhchnccspccvmvwwzpwzzmddjmdmbdmmrzmmhlhhhdndllrlgrllmlhljlmmgdmggwdggffblbmmdgdwgdgwgvgcgtctjjnfnsffbqbwbnnsbbqsswggncgncntccqqfmmlqllllvrvlrlgldlggjvvqdvqvzvzpzrrvfvcfcqfcflfjfjrrwbrrpnrrvzzbddfdgfdgfddppbdbbjddtcdtccllvccjtctmccsttfcfppmvppbvpvjpvprvvmggjffbqbbqhbbcdbdrbrjrllgmggwdwzddzdczddgpgglgpgqgmgllrqlqmlqllmbmzmdzdbzddqbbzwwjfjqqlrrzgrrlzzdczddlflpfpqfqrqzzpdzdnznwwvjjnndldpdppfgppgwwnddmzzmffvgggphpbpnbblqbqccswwlcwlltvvlggqvqhvvtstmssbvvflvvhdhggqpgqgqlqggjvjpphhqnhqhvqhvqvpvvfvqfqvvbmbtmmqpqccwcbbqwbbmjbjsscsqqcccbjbvvmsmrmwrwwbhwwdpwphprptrrdssrprjrdrssqtqzqtzzcbbvrrpwrwlwbbpwwrddfcfccvttdsshqhqddsmslsffdsdrrswsmmztzhzghgqhqbbfcctmcmmdwwpbpdbbnjbnbmnmqqqftfdfnfzfqzffmmnqqgfgwwntnwwfsfmssnzzscsmmzttdwttfppnccngggmrmbmccrbcrclcslsfspfsswnwpwjwddbnbjbrjbrjbrjbrrlgljggcpgptpltlmlnnjpnptnppdcdwcwfcwcnnzddbrrnbnnsjsnjjjsqjjqhjjbrjbbghbgggsdshswsrwwqbwqqmtqmqdmdttwfwzztwztwtfwtwtfwwjpwjjljcccdbdndmmhjhzzszfssgbbwbhhhrhfrhhwttwltwtbwbrbqbpbwwjtwwdjjwhwmmddhgdhhhdrhrjjngjgnjnfjnjrjtrrhmmjzzsjzjhjmmvnmnqqzbbtnncffnhnhgnhggcssvrrwfwjwgjwwwdtwddgrrwnwffndnbdnbnsnbsnndtdvvdtdsdhshcczqzztzfzdzndnnhqqzggwrwtrtvtjvjvsjjzhzggtffdbbzwbbnwwnhnpnznfncnqqvmvbmbcbgcgfggtpggjqggnppwmwzzqpzzvvgqqjjhrrmmfsfvvbqvbqqptpztpzzhnndgngdngdngnllslhhsvssdffwllchlccjpjdpddgcgrgttmqttjlttphhdwdtdtnnrggmhhmhmgghnhbhppfmmlrmmlqqsllwswpsshbbfjjqvvlsvvblbljltjtjsszcscmsmgmddzsdddznnvvddwbwjwwmqwqlqvqffptfpttgngpgttlglpgppssthshwhzhshfshssstppbpjjtgjttlsszmzccrllwjjcdccgmccdppnlnrlltntcnttrhtrtqqfhhjfffldfdldbbqjqzzqjzzfhhtvvrrfqfsqfftrtbblmlsltsszqqcsshllvlbbpgpzgpgcppwnpwnwpnnjjmllrhllfzlzglzlnlrrcssjjjtgjgjjznjnmmjjpccqrqzrzzmfzfczcssnttddfjdfjfpjjmqjqnqtqbqzzqqzwwzwqqfccvcrvrqrlqrlqqnvjtqswzvngfcjpmnrnvnwtwnjvsmzhtwzpjbpglchwfvwhvznsvhvwwjppmqqpcpmzrznqrlvbgdfcpgdtfhwdclvzjqlhtbdvsgpjlrgbcjblnqhffbcjfwsgssfzlsbhrptfgsfsstzbwqcsrpgftblrnldhwfwpgpffftsjgclzqmjmcvwjrsbhgdblswrwnhpjtgsggmnjqgzzctjjztwhcqvhqfvddljjtqwgpmwdsmmhdttvdpqpvsqbpwmtzgfthtmfhmplmwqcbmdmrwqmmzmjmfdbqspmshlhtbmbcpcjsgdccwmbfwvftlshtrgzvbndqvqjzqgbgrnmzbwfgntfphjrvhrgzgdqclvpvwffghthlqwlghfqrwpdmgnthqwznqsjrnnpghfcfwctpvnbnftczlhmdslfvqprhgqmzmzsjvtzfsfzlcrltjhfgmwqcvnzmttfvvbsjslqfwmnhgbbjdwfgbzsjqfsgvphvmclfgtmcvlpslpqfsbzgccqslmrgdwrtlrzbbvrjrnnnncgrnsggzjrfqtmhjdvdfbwdmqrjbghrbnhpqcdzgbqwrvrcpwdlbvrdpfhnpbncjzgmftjhvwnplmnlfnlfjsjnqhtgqldzqlrlqtdjndjpsfdcdfrwtqblzpsqjvnqchdhwvswrmczhsbpfggsvzdznqjlrjjbcjnsjvqtrtttmmcgdwbqcthqvzffjmdbvjmjvcrmnpjgtjshbnlqpdfdnbcfmbrzsvqftrnfzmjdhpprpnwqbngmbbwjvmdzbwvttncdtgqnwwchmbbdtrwlflmqnbthnczfpmtpfpqpbwbcpsplgfpjfptdpvzjnbgzrfdwpdrztqtsrzmbfqhgwnfzcsbdsjsmbdghjcjlvbpjpplgqqnbqpqgsqqbmpgmlghrlbcfzjhlqfgdpfljspwqjbsjqzwwhrcpfrhwpvgrjpqjzfzphcrwbfwsjdsjtlwctsfhrmbnvsrfwwvgqtjtjvvqzjznlrsblgthjfrphsfmbtpmbthwdhrqbdmbzplbvpbcwvhgrsjccsnhbrqdbljzpdttbffqrbmgmzsmhdhsmnnmjqtwdjpmhlpwtwhvbfnjzfcwfzfplsbqgcvwgjcbwzbzmqdchwrggjwgjbttsttsztrftttqpslwvtcrjmdtwdhlwnhpjstqnqtvrmlmtcgjljzrthgpmvdjzlwfntqmbpdpgmmvvwqmdqqwrnlsrmhrpdtmhjrngwdfgddlrmdnfdnscjhdfjzwljjrsclnfdmhpbsvwtsmrdsvmpbjjpmmgtfclcccmcnzcslsvdwncrgtpvgbcgwdmcqlthgmrqmpnprlsqgzzpzzmhgflfgpjwgjjdpvggmhcstrwscqggqgrrjwtqzdfbnwgtvslvghfnzphbznqslcwwcsplgwjnltrttqzcvjhfdrwgjpclzmqfgvhzhrcdsgchhfqptqjwffmrsjrplzzlhnptwlmrvtstsrgnfdnrbtdbzjdcbthhtnjdprrpgtgfjsqnpgslcqgmdfpsrdfvhbqvvpthmmshpdnrrwlfcmqfbrsvqdqhffgbdhwjgcjsclcqpwnrfzfdqcvnmqnjmjnvhqmznmbnbnnjfrtlvbpdgglqpgcmqqcnpzfvvsnchpbjprpnwbdqvqzgjvgtnsrvswfmwhzllmlgpsglssnhcvbjtfghhrznpzntwwtnshmhhddnntdljhhhpmnchssqthbzpqmtmjbcfvmgnmwhpzrbwzzvzmnfdcsbvzphlglbhjpfmrtgfblhtszqvbbmtglwdhgjdvvgtpscgvwzjppfnlndnmtrnnnlfbgmrpqlvhvbgzmwghnsmdmdrftqpqncsbcmqhhhljzlwcrlsdbhrlddwlhcghvttjfsmfdzcllswjgsmcmghbflbdgpwfqplqnrvzfnctdsnmldhtbtpfrsztjdsgmnbrdjwbrgqlhdrlrnmlpwltgpwhwztbwpcqtwbqdmsfdfczftncvsggshhcqbjgcwjljcqdpczrnzbjhrhwcgrbbqzmmfjpqwrwppmnvcsfwprjqvtnzqzwtwlvvqssfjzbrvjjrmphtbjbrzttmvvhdfsnqdmpfbtprbqgzdgtjtpvbqqsgppsrnvsfnmgvbbsjcpttffthpvfjpnzmsjmpdzbldggtjrjqpshtmgpfgtcstdrgjhzjr$"


