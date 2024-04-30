package br.ufscar.dc.compiladores.alguma.grammar;

import main.java.br.ufscar.dc.compiladores.alguma.grammar.AlgumaSemanticoUtils;
import main.java.br.ufscar.dc.compiladores.alguma.grammar.TabelaDeSimbolos.TipoAlguma;

public class AlgumaSemantico extends ExpressoesBaseVisitor<Double> {
    @Override
    public Double visitPrograma(ProgramaContext ctx){
        return visitExpressao(ctx.expressao());
    }
    
    public Void visitDeclaracao(DeclaracaoContext ctx){
        String nomeVar = ctx.VARIAVEL().getText();
        String strTipoVar = ctx.TIPO_VAR().getText();

        TipoAlguma tipoVar = TipoAlguma.INVALIDO;

        switch(strTipoVar){
            case "INTEIRO":
                tipovar = TipoAlguma.INTEIRO;
            case "REAL":
                tipovar = TipoAlguma.REAL;
            case "LITERAL":
                tipovar = TipoAlguma.LITERAL;
            case "BOOL":
                tipovar = TipoAlguma.BOOL;
        }

        // Verificar se a variável já foi declarada
        if (tabela.existe(nomeVar)) {
            AlgumaSemanticoUtils.adicionarErroSemantico(ctx.VARIAVEL().getSymbol(), "Variável " + nomeVar + " já existe");
        } else {
            tabela.adicionar(nomeVar, tipoVar);
        }

        return super.visitDeclaracao(ctx);
    }
    

    @Override
    public Void visitComandoAtribuicao(AlgumaParser.ComandoAtribuicaoContext ctx) {
        TipoAlguma tipoExpressao = AlgumaSemanticoUtils.verificarTipo(tabela, ctx.expressaoAritmetica());
        if (tipoExpressao != TipoAlguma.INVALIDO) {
            String nomeVar = ctx.VARIAVEL().getText();
            if (!tabela.existe(nomeVar)) {
                AlgumaSemanticoUtils.adicionarErroSemantico(ctx.VARIAVEL().getSymbol(), "Variável " + nomeVar + " não foi declarada antes do uso");
            } else {
                TipoAlguma tipoVariavel = AlgumaSemanticoUtils.verificarTipo(tabela, nomeVar);
                if (tipoVariavel != tipoExpressao) {
                    AlgumaSemanticoUtils.adicionarErroSemantico(ctx.VARIAVEL().getSymbol(), "Tipo da variável " + nomeVar + " não é compatível com o tipo da expressão");
                }
            }
        }
        return super.visitComandoAtribuicao(ctx);
    }

    @Override
    public Void visitComandoEntrada(AlgumaParser.ComandoEntradaContext ctx) {
        String nomeVar = ctx.VARIAVEL().getText();
        if (!tabela.existe(nomeVar)) {
            AlgumaSemanticoUtils.adicionarErroSemantico(ctx.VARIAVEL().getSymbol(), "Variável " + nomeVar + " não foi declarada antes do uso");
        }
        return super.visitComandoEntrada(ctx);
    }

    @Override
    public Void visitExpressaoAritmetica(AlgumaParser.ExpressaoAritmeticaContext ctx) {
        AlgumaSemanticoUtils.verificarTipo(tabela, ctx);
        return super.visitExpressaoAritmetica(ctx);
    }

}