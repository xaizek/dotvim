XPTemplate priority=personal

XPT class
class `ClassName^ {
public:
    explicit `ClassName^(`ctorParam^);
    ~`ClassName^();
    `cursor^

private:
    `ClassName^(const `ClassName^& _rhs);
    `ClassName^& operator=(const `ClassName^& _rhs);
};
..XPT

XPT for wrap " for (int ..;..;++)
for`$SPcmd^(`$SParg^`$FOR_SCOPE^int `$VAR_PRE`i^`$SPop^=`$SPop^`0^; `i^`$SPop^<`$SPop^`len^; ++`i^`$SParg^)`$BRloop^{
    `cursor^
}

XPT forr wrap " for (int ..;..;--)
for`$SPcmd^(`$SParg^`$FOR_SCOPE^int `$VAR_PRE`i^`$SPop^=`$SPop^`0^; `i^`$SPop^>`=$SPop`end^; --`i^`$SParg^)`$BRloop^{
    `cursor^
}
