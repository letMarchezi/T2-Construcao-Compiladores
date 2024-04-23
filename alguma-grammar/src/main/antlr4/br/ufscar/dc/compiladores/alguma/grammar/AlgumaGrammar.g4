grammar AlgumaGrammar;

PALAVRA_CHAVE :	'algoritmo' | 'declare' | 'inteiro' | 'real' | 'literal'  | 'leia' | 'escreva' | 'fim_algoritmo' |
 'logico' | 'se' | 'entao' | 'senao' | 'fim_se' | 'fim_caso' | 'seja' | 'caso' | 'para' | 'ate' | 'faca' |
 'fim_para' | 'enquanto' | 'fim_enquanto' | 'registro' | 'fim_registro' | 'tipo' | 'procedimento' | 'funcao' |
 'retorne' | 'constante' | 'var' | 'fim_procedimento' | 'fim_funcao'; 

OP_REL:	'>' | '>=' | '<' | '<=' | '<>' | '=';

OP_ARIT: '+' | '-' | '*' | '/' | '%' | '^';

OP_LOG: 'e' | 'nao' | 'ou' | 'falso' | 'verdadeiro';

CARACTERE_ESP: ',' | ':' | '(' | ')' | '<-' | '-' | '..' | '.' | '[' | ']' | '&';

NUM_INT: ('0'..'9')+;

NUM_REAL: ('0'..'9')+ ('.' ('0'..'9')+)?;

IDENT: ('a'..'z'|'A'..'Z') ('_'|'a'..'z'|'A'..'Z'|'0'..'9')*;

CADEIA : ('"' ( ESC_SEQ | ~('"'|'\\'|'\n') )* '"' ) | ('\'' ( ESC_SEQ_SQ | ~('\''|'\\'|'\n') )* '\'');

fragment ESC_SEQ : '\\"';
fragment ESC_SEQ_SQ : '\\\'';

COMENTARIO : '{' ~('\n'|'}')* '}' -> skip;

CADEIA_NAO_FECHADA: ('\'' (ESC_SEQ_SQ | ~('\n'|'\''|'\\'))* '\n') | ('"' ( ESC_SEQ | ~('\n'|'"'|'\\'))* '\n');

COMENTARIO_NAO_FECHADO: '{' (~('\n'|'}'))* '\n';

WS: (' ' | '\t' | '\r' | '\n') {skip();};


programa : 
    {System.out.println("Começou o programa!");} declaracoes { System.out.println("Declaracoes"); } 'algoritmo' corpo 'fim_algoritmo' <EOF>;

op_logico_1 : 'ou';

op_logico_2 : 'e';

declaracoes : 
    {System.out.println("global");} decl_local_global*;

tipo_basico : 'literal' | 'inteiro' | 'real' | 'logico';

identificador : IDENT { System.out.println("IDENT: "+$IDENT.text+""); }  ('.' IDENT)* dimensao;

variavel : identificador (',' identificador)* {System.out.println("Buscando outros identificadores");} ':' {System.out.println("Leu os :");} tipo {System.out.println("Leu o tipo");};

decl_local_global : {System.out.println("Antes do local");} declaracao_local {System.out.println("Depois do local");} | declaracao_global;

tipo_basico_ident : { System.out.println("tipo: "+$tipo_basico.text+""); } tipo_basico | IDENT;

declaracao_local : 'declare' variavel
                  | 'constante' IDENT ':' tipo_basico '=' valor_constante
                  | 'tipo' IDENT ':' tipo;

dimensao : ('[' exp_aritmetica ']')*;

tipo : registro | tipo_estendido;

tipo_estendido : ('^')? tipo_basico_ident;

valor_constante : CADEIA | NUM_INT | NUM_REAL | 'verdadeiro' | 'falso';

registro : 'registro' variavel* 'fim_registro';

declaracao_global : 'procedimento' IDENT '(' parametros? ')' declaracao_local* cmd* 'fim_procedimento'
    | 'funcao' IDENT '(' parametros? ')' ':' tipo_estendido declaracao_local* cmd* 'fim_funcao';

parametro : ('var')? identificador (',' identificador)* ':' tipo_estendido;

parametros : parametro (',' parametro)*;

corpo : declaracao_local* cmd*;

cmd : cmdLeia | cmdEscriva | cmdSe | cmdCaso | cmdPara | cmdEnquanto
    | cmdAtribuica | cmdChamada | cmdRetorne;

cmdLeia : 'leia' '(' ('^')? identificador (',' ('^')? identificador)* ')';

cmdEscriva : 'escreva' '(' expressao (',' expressao)* ')';

cmdSe : 'se' expressao 'entao' cmd* ('senao' cmd)? 'fim_se';

cmdCaso : 'caso' exp_aritmetica 'seja' selecao ('senao' cmd)? 'fim_caso';

cmdPara : 'para' IDENT '<-' exp_aritmetica 'ate' exp_aritmetica 'faca' cmd* 'fim_para';

cmdEnquanto : 'enquanto' expressao 'faca' cmd* 'fim_enquanto';

cmdFaca : 'faca' cmd 'ate' expressao;

cmdAtribuica : ('^')? identificador '<-' expressao;

cmdChamada : IDENT '(' expressao? (',' expressao)* ')';

cmdRetorne : 'retorne' expressao;

selecao : item_selecao*;

item_selecao : constantes ':' cmd;

constantes : numero_intervalo;

numero_intervalo : (op_unario)? NUM_INT ('..' (op_unario)? NUM_INT)?;

op_unario : '-';

exp_aritmetica : termo (op1 termo)*;

termo : fator (op2 fator)*;

fator : parcela (op3 parcela)*;

op1 : '+';

op2 : '*';

op3 : '^';

parcela : (op_unario)? parcela_unario | parcela_nao_unario;

parcela_unario : ('^')? identificador
               | IDENT '(' expressao (',' expressao)* ')'
               | NUM_INT
               | NUM_REAL
               | '(' expressao ')';

parcela_nao_unario : '&' identificador | CADEIA;

exp_relacional : exp_aritmetica (op_relacional exp_aritmetica)?;

op_relacional : '>' | '>=' | '<' | '<=' | '<>' | '=';

expressao : termo_logico (op_logico_1 termo_logico)*;

termo_logico : fator_logico (op_logico_2 fator_logico)*;

fator_logico : ('nao')? parcela_logica;

parcela_logica : ('verdadeiro' | 'falso') 
               | exp_relacional;


