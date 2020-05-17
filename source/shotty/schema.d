/++
This module was automatically generated from the following grammar:


ShottySchema:
    Scheme   < Entry*
    Entry    < "%" (ConstStr / Random)
    Value    < :"{" (Number / String) :"}"
    Random   < "r" Type Value
    ConstStr < "s" Value

    Type     < Hex / Alpha / Num
    Hex      < "x" 
    Alpha    < "a"
    Num      < "n"

    String   < ~([aA-zZ\_\-]+)
    Number   < ~([0-9]+)


+/
module shotty.schema;

public import pegged.peg;
import std.algorithm: startsWith;
import std.functional: toDelegate;

struct GenericShottySchema(TParseTree)
{
    import std.functional : toDelegate;
    import pegged.dynamic.grammar;
    static import pegged.peg;
    struct ShottySchema
    {
    enum name = "ShottySchema";
    static ParseTree delegate(ParseTree)[string] before;
    static ParseTree delegate(ParseTree)[string] after;
    static ParseTree delegate(ParseTree)[string] rules;
    import std.typecons:Tuple, tuple;
    static TParseTree[Tuple!(string, size_t)] memo;
    static this()
    {
        rules["Scheme"] = toDelegate(&Scheme);
        rules["Entry"] = toDelegate(&Entry);
        rules["Value"] = toDelegate(&Value);
        rules["Random"] = toDelegate(&Random);
        rules["ConstStr"] = toDelegate(&ConstStr);
        rules["Type"] = toDelegate(&Type);
        rules["Hex"] = toDelegate(&Hex);
        rules["Alpha"] = toDelegate(&Alpha);
        rules["Num"] = toDelegate(&Num);
        rules["String"] = toDelegate(&String);
        rules["Number"] = toDelegate(&Number);
        rules["Spacing"] = toDelegate(&Spacing);
    }

    template hooked(alias r, string name)
    {
        static ParseTree hooked(ParseTree p)
        {
            ParseTree result;

            if (name in before)
            {
                result = before[name](p);
                if (result.successful)
                    return result;
            }

            result = r(p);
            if (result.successful || name !in after)
                return result;

            result = after[name](p);
            return result;
        }

        static ParseTree hooked(string input)
        {
            return hooked!(r, name)(ParseTree("",false,[],input));
        }
    }

    static void addRuleBefore(string parentRule, string ruleSyntax)
    {
        // enum name is the current grammar name
        DynamicGrammar dg = pegged.dynamic.grammar.grammar(name ~ ": " ~ ruleSyntax, rules);
        foreach(ruleName,rule; dg.rules)
            if (ruleName != "Spacing") // Keep the local Spacing rule, do not overwrite it
                rules[ruleName] = rule;
        before[parentRule] = rules[dg.startingRule];
    }

    static void addRuleAfter(string parentRule, string ruleSyntax)
    {
        // enum name is the current grammar named
        DynamicGrammar dg = pegged.dynamic.grammar.grammar(name ~ ": " ~ ruleSyntax, rules);
        foreach(name,rule; dg.rules)
        {
            if (name != "Spacing")
                rules[name] = rule;
        }
        after[parentRule] = rules[dg.startingRule];
    }

    static bool isRule(string s)
    {
		import std.algorithm : startsWith;
        return s.startsWith("ShottySchema.");
    }
    mixin decimateTree;

    alias spacing Spacing;

    static TParseTree Scheme(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Entry, Spacing)), "ShottySchema.Scheme")(p);
        }
        else
        {
            if (auto m = tuple(`Scheme`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Entry, Spacing)), "ShottySchema.Scheme"), "Scheme")(p);
                memo[tuple(`Scheme`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Scheme(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Entry, Spacing)), "ShottySchema.Scheme")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Entry, Spacing)), "ShottySchema.Scheme"), "Scheme")(TParseTree("", false,[], s));
        }
    }
    static string Scheme(GetName g)
    {
        return "ShottySchema.Scheme";
    }

    static TParseTree Entry(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("%"), Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.wrapAround!(Spacing, ConstStr, Spacing), pegged.peg.wrapAround!(Spacing, Random, Spacing)), Spacing)), "ShottySchema.Entry")(p);
        }
        else
        {
            if (auto m = tuple(`Entry`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("%"), Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.wrapAround!(Spacing, ConstStr, Spacing), pegged.peg.wrapAround!(Spacing, Random, Spacing)), Spacing)), "ShottySchema.Entry"), "Entry")(p);
                memo[tuple(`Entry`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Entry(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("%"), Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.wrapAround!(Spacing, ConstStr, Spacing), pegged.peg.wrapAround!(Spacing, Random, Spacing)), Spacing)), "ShottySchema.Entry")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("%"), Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.wrapAround!(Spacing, ConstStr, Spacing), pegged.peg.wrapAround!(Spacing, Random, Spacing)), Spacing)), "ShottySchema.Entry"), "Entry")(TParseTree("", false,[], s));
        }
    }
    static string Entry(GetName g)
    {
        return "ShottySchema.Entry";
    }

    static TParseTree Value(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("{"), Spacing)), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Number, Spacing), pegged.peg.wrapAround!(Spacing, String, Spacing)), Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("}"), Spacing))), "ShottySchema.Value")(p);
        }
        else
        {
            if (auto m = tuple(`Value`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("{"), Spacing)), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Number, Spacing), pegged.peg.wrapAround!(Spacing, String, Spacing)), Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("}"), Spacing))), "ShottySchema.Value"), "Value")(p);
                memo[tuple(`Value`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Value(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("{"), Spacing)), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Number, Spacing), pegged.peg.wrapAround!(Spacing, String, Spacing)), Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("}"), Spacing))), "ShottySchema.Value")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("{"), Spacing)), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Number, Spacing), pegged.peg.wrapAround!(Spacing, String, Spacing)), Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("}"), Spacing))), "ShottySchema.Value"), "Value")(TParseTree("", false,[], s));
        }
    }
    static string Value(GetName g)
    {
        return "ShottySchema.Value";
    }

    static TParseTree Random(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("r"), Spacing), pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Value, Spacing)), "ShottySchema.Random")(p);
        }
        else
        {
            if (auto m = tuple(`Random`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("r"), Spacing), pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Value, Spacing)), "ShottySchema.Random"), "Random")(p);
                memo[tuple(`Random`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Random(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("r"), Spacing), pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Value, Spacing)), "ShottySchema.Random")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("r"), Spacing), pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Value, Spacing)), "ShottySchema.Random"), "Random")(TParseTree("", false,[], s));
        }
    }
    static string Random(GetName g)
    {
        return "ShottySchema.Random";
    }

    static TParseTree ConstStr(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("s"), Spacing), pegged.peg.wrapAround!(Spacing, Value, Spacing)), "ShottySchema.ConstStr")(p);
        }
        else
        {
            if (auto m = tuple(`ConstStr`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("s"), Spacing), pegged.peg.wrapAround!(Spacing, Value, Spacing)), "ShottySchema.ConstStr"), "ConstStr")(p);
                memo[tuple(`ConstStr`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree ConstStr(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("s"), Spacing), pegged.peg.wrapAround!(Spacing, Value, Spacing)), "ShottySchema.ConstStr")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("s"), Spacing), pegged.peg.wrapAround!(Spacing, Value, Spacing)), "ShottySchema.ConstStr"), "ConstStr")(TParseTree("", false,[], s));
        }
    }
    static string ConstStr(GetName g)
    {
        return "ShottySchema.ConstStr";
    }

    static TParseTree Type(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Hex, Spacing), pegged.peg.wrapAround!(Spacing, Alpha, Spacing), pegged.peg.wrapAround!(Spacing, Num, Spacing)), "ShottySchema.Type")(p);
        }
        else
        {
            if (auto m = tuple(`Type`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Hex, Spacing), pegged.peg.wrapAround!(Spacing, Alpha, Spacing), pegged.peg.wrapAround!(Spacing, Num, Spacing)), "ShottySchema.Type"), "Type")(p);
                memo[tuple(`Type`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Type(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Hex, Spacing), pegged.peg.wrapAround!(Spacing, Alpha, Spacing), pegged.peg.wrapAround!(Spacing, Num, Spacing)), "ShottySchema.Type")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Hex, Spacing), pegged.peg.wrapAround!(Spacing, Alpha, Spacing), pegged.peg.wrapAround!(Spacing, Num, Spacing)), "ShottySchema.Type"), "Type")(TParseTree("", false,[], s));
        }
    }
    static string Type(GetName g)
    {
        return "ShottySchema.Type";
    }

    static TParseTree Hex(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("x"), Spacing), "ShottySchema.Hex")(p);
        }
        else
        {
            if (auto m = tuple(`Hex`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("x"), Spacing), "ShottySchema.Hex"), "Hex")(p);
                memo[tuple(`Hex`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Hex(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("x"), Spacing), "ShottySchema.Hex")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("x"), Spacing), "ShottySchema.Hex"), "Hex")(TParseTree("", false,[], s));
        }
    }
    static string Hex(GetName g)
    {
        return "ShottySchema.Hex";
    }

    static TParseTree Alpha(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("a"), Spacing), "ShottySchema.Alpha")(p);
        }
        else
        {
            if (auto m = tuple(`Alpha`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("a"), Spacing), "ShottySchema.Alpha"), "Alpha")(p);
                memo[tuple(`Alpha`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Alpha(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("a"), Spacing), "ShottySchema.Alpha")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("a"), Spacing), "ShottySchema.Alpha"), "Alpha")(TParseTree("", false,[], s));
        }
    }
    static string Alpha(GetName g)
    {
        return "ShottySchema.Alpha";
    }

    static TParseTree Num(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("n"), Spacing), "ShottySchema.Num")(p);
        }
        else
        {
            if (auto m = tuple(`Num`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("n"), Spacing), "ShottySchema.Num"), "Num")(p);
                memo[tuple(`Num`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Num(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("n"), Spacing), "ShottySchema.Num")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("n"), Spacing), "ShottySchema.Num"), "Num")(TParseTree("", false,[], s));
        }
    }
    static string Num(GetName g)
    {
        return "ShottySchema.Num";
    }

    static TParseTree String(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.literal!("a"), pegged.peg.charRange!('A', 'z'), pegged.peg.literal!("Z"), pegged.peg.literal!(`\`), pegged.peg.literal!("_"), pegged.peg.literal!("-")), Spacing)), Spacing)), "ShottySchema.String")(p);
        }
        else
        {
            if (auto m = tuple(`String`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.literal!("a"), pegged.peg.charRange!('A', 'z'), pegged.peg.literal!("Z"), pegged.peg.literal!(`\`), pegged.peg.literal!("_"), pegged.peg.literal!("-")), Spacing)), Spacing)), "ShottySchema.String"), "String")(p);
                memo[tuple(`String`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree String(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.literal!("a"), pegged.peg.charRange!('A', 'z'), pegged.peg.literal!("Z"), pegged.peg.literal!(`\`), pegged.peg.literal!("_"), pegged.peg.literal!("-")), Spacing)), Spacing)), "ShottySchema.String")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.literal!("a"), pegged.peg.charRange!('A', 'z'), pegged.peg.literal!("Z"), pegged.peg.literal!(`\`), pegged.peg.literal!("_"), pegged.peg.literal!("-")), Spacing)), Spacing)), "ShottySchema.String"), "String")(TParseTree("", false,[], s));
        }
    }
    static string String(GetName g)
    {
        return "ShottySchema.String";
    }

    static TParseTree Number(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.charRange!('0', '9'), Spacing)), Spacing)), "ShottySchema.Number")(p);
        }
        else
        {
            if (auto m = tuple(`Number`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.charRange!('0', '9'), Spacing)), Spacing)), "ShottySchema.Number"), "Number")(p);
                memo[tuple(`Number`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Number(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.charRange!('0', '9'), Spacing)), Spacing)), "ShottySchema.Number")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.charRange!('0', '9'), Spacing)), Spacing)), "ShottySchema.Number"), "Number")(TParseTree("", false,[], s));
        }
    }
    static string Number(GetName g)
    {
        return "ShottySchema.Number";
    }

    static TParseTree opCall(TParseTree p)
    {
        TParseTree result = decimateTree(Scheme(p));
        result.children = [result];
        result.name = "ShottySchema";
        return result;
    }

    static TParseTree opCall(string input)
    {
        if(__ctfe)
        {
            return ShottySchema(TParseTree(``, false, [], input, 0, 0));
        }
        else
        {
            forgetMemo();
            return ShottySchema(TParseTree(``, false, [], input, 0, 0));
        }
    }
    static string opCall(GetName g)
    {
        return "ShottySchema";
    }


    static void forgetMemo()
    {
        memo = null;
    }
    }
}

alias GenericShottySchema!(ParseTree).ShottySchema ShottySchema;

