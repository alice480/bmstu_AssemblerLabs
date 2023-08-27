from lexical_analysis import LexicalAnalysis
from syntactic_analysis import SyntacticAnalysis

# service_words = ['var', 'case', 'end', 'of']
# types = ['integer', 'real', 'char', 'byte']
# separators = [':', ';', ',', '(', ')']


if __name__ == '__main__':
    analyzed_string = input()
    while analyzed_string != 'all':
        la = LexicalAnalysis(analyzed_string)
        token_str = la.lexical_analysis()
        if len(token_str):
            sa = SyntacticAnalysis(token_str)
            print(token_str)
            if sa.syntactic_analysis():
                print('OK')
            else:
                print('NO: Error at the syntactic stage')
        else:
            print('NO: Error at the stage of lexical analysis')
        analyzed_string = input()


# OK
# var a: record b: real; end;
# var a: record case f of 1: (b: real;) 2: (ch: char;) 3: (bt: byte;) end; end;
# var a: record case f of 1: b: real; 2: (ch: char;) end; end;

# Lexical Error:
# var %a: record b: integer; end;
# var 1a: record b: char; end;

# Syntactic Error:
# var a: case f of 1: d: integer; end;
