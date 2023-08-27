class SyntacticAnalysis:
    def __init__(self, tokens):
        self.tokens = tokens
        self.automat = {
            '_swvr': ['_idid'],
            '_idid': ['_spcm', '_spcl', '_swof'],
            '_spcm': ['_idid'],
            '_spcl': ['_tprd', '_tpit', '_tpch', '_tpbt', '_tprl', '_splb', '_idid'],
            '_tprd': ['_idid', '_swcs'],
            '_tpit': ['_spsm', '_sprb'],
            '_tprl': ['_spsm', '_sprb'],
            '_tpch': ['_spsm', '_sprb'],
            '_tpbt': ['_spsm', '_sprb'],
            '_swcs': ['_idid'],
            '_swof': ['_litr'],
            '_litr': ['_spcl'],
            '_spsm': ['_sprb', '_swed', '_idid', '_swcs', '_litr'],
            '_swed': ['_spsm'],
            '_splb': ['_idid'],
            '_sprb': ['_litr', '_swed']
        }

    @staticmethod
    def pairing_check(stack, lexeme) -> bool:
        last = stack.pop(-1)
        return lexeme == '_swed' and (last == '_tprd' or last == '_swcs') or lexeme == '_sprb' and last == '_splb'

    def syntactic_analysis(self):
        # stack for paired designs record-end, case-end, (-)
        first_part = ['_tprd', '_swcs', '_splb']
        second_part = ['_swed', '_sprb']
        stack = []
        condition = True
        # the previous token for comparison with the current one
        previous = self.tokens[0:5]
        current = previous
        index = 5
        while index < len(self.tokens) and condition:
            current = self.tokens[index:index + 5]
            if current in first_part:
                stack.append(current)
            elif current in second_part:
                condition = SyntacticAnalysis.pairing_check(stack, current)
            try:
                self.automat[previous].index(current)
            except ValueError:
                condition = False
            previous = current
            index += 5
        # the string ends with ;
        # the string does not consist of a single token
        # all paired symbols have a pair
        condition *= current == '_spsm' and len(self.tokens) > 5 and len(stack) == 0
        return condition
