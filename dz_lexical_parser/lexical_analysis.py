class LexicalAnalysis:
    def __init__(self, line):
        self.analyzed = line
        # automat for reserved words
        self.automat = {'integer':  [1, '_tpit'],
                        'record':   [1, '_tprd'],
                        'char':     [1, '_tpch'],
                        'byte':     [1, '_tpbt'],
                        'real':     [1, '_tprl'],
                        'case':     [1, '_swcs'],
                        'var':      [1, '_swvr'],
                        'end':      [1, '_swed'],
                        'of':       [1, '_swof'],
                        ':':        [1, '_spcl'],
                        ';':        [1, '_spsm'],
                        ',':        [1, '_spcm'],
                        '(':        [1, '_splb'],
                        ')':        [1, '_sprb'],
                        }

        # automat for identifier
        self.id_automat = {}
        for numeric in range(ord('0'), ord('9') + 1):
            self.id_automat[chr(numeric)] = [-1, 1]
        for letter in range(ord('A'), ord('Z') + 1):
            self.id_automat[chr(letter)] = [1, 1]
        for letter in range(ord('a'), ord('z') + 1):
            self.id_automat[chr(letter)] = [1, 1]
        self.id_automat['_'] = [1, 1]

        # automat for literal
        self.lit_automat = {}
        for numeric in range(ord('0'), ord('9')):
            self.lit_automat[chr(numeric)] = 1

    def check_lit(self, lexeme):
        condition = 0
        while len(lexeme) and condition >= 0:
            try:
                condition = self.lit_automat[lexeme[0]]
            except KeyError:
                condition = -1
            lexeme = lexeme[1:]
        token = ''
        if condition > 0:
            token += '_litr'
        return token

    def check_id(self, lexeme):
        condition = 0
        while len(lexeme) and condition >= 0:
            try:
                condition = self.id_automat[lexeme[0]][condition]
            except KeyError:
                condition = -1
                print('Incorrect id: ', lexeme)
            lexeme = lexeme[1:]
        token = ''
        if condition > 0:
            token += '_idid'
        return token

    def str_processing(self):
        self.analyzed.lower()
        self.analyzed += ' '
        lexems = []
        separators = [':', ';', ',', '(', ')']
        start = 0
        for i in range(len(self.analyzed)):
            if self.analyzed[i] == ' ':
                if i - start > 0:
                    lexems.append(self.analyzed[start:i])
                start = i + 1
            elif self.analyzed[i] in separators:
                if i - start > 0:
                    lexems.append(self.analyzed[start:i])
                lexems.append(self.analyzed[i])
                start = i + 1
        self.analyzed = lexems

    def lexical_analysis(self):
        condition = 1
        tokens = ''
        self.str_processing()
        while len(self.analyzed) and condition >= 0:
            # string without spaces
            lexeme = self.analyzed[0]
            try:
                condition = self.automat[lexeme][0]
                tokens += self.automat[lexeme][1]
            except KeyError:
                lit = self.check_lit(lexeme)
                id = self.check_id(lexeme)
                condition = len(id) + len(lit) - 1
                tokens += id + lit
            self.analyzed.pop(0)

        if not condition > 0 or len(self.analyzed):
            tokens = ''
        return tokens
