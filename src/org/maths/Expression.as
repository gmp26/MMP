package org.maths {public class Expression implements IExpression {		//	// A compiler for a language of complex-valued mathematical expressions.	//	// The grammar for this language is:		//	//// Expression -> LTerm SYMBOL RTerm  // where SYMBOL is a command	////			  |  CExpression (RELOP CExpression)?	////			;	//	// Expression -> Command ( parameters* )	//			  |  RTerm	//            |  LTerm SYMBOL RTerm  // a command	//			;		// Lterm -> Symbol	//			;	//	// RTerm -> SetExpression | CExpression 	//        ;	// 	// Command -> Symbol	//		    ;	//	// Parameter -> RTerm	//			  ;	//	// CExpression -> Term (ADDOP Term)*	//				;	//	// SExpression -> '{' CExpression (COMMA CExpression)* '}'	//				      ;	//	// %%	// %% Expression -> Term (ADDOP Term)*	// %%			;	//	// Term -> Factor (MULOP Factor)*	//			;	//	// Factor -> ADDOP Factor | Power	//			;	//	// Power -> Atom (POWOP Factor)?	//			;	//	// Atom ->  '(' Expression ')' | NUMBER | SYMBOL | Function	//			;	//	// Function -> CFUNC1 Atom 	//			| CFUNC2 '(' Expression COMMA Expression ')' 	//       	;	//	//	// An expression may be one of the following objects:	// 		a complex number, 	//		a complex expression, 	//		a variable	//		other things that we may need but I haven't thought of yet!	//	// Expressions may include definitions. The value of the definition is the	// value of the object that is defined.	// 	e.g. 	//		a = 1		// defines a and has value 1	//		a = b = 1 	// defines b as 1, defines a as the value of 'b = 1', which is 1.	//	// Some constant sets could be predefined: (C,R,Z,N)	//	// Some constant numbers are defines:	//		i 	= +sqrt(-1)	//		pi 	= Math.PI	//		e	= Math.E	//	// also perhaps:	//		red	= 2^16	//		green = 2^8	//		blue = 2^0	//	// See Complex.as for the list of functions that are predefined	// (exp, ln, pow, negate, conjugate, sin, cos, tan etc.)	//	// Here is some sample code we wish to compile:	//	t > 0			// t is Real and greater than zero (returns t)	//	t < 1			// t is Real and less than 1 (returns t)	//  z = 2*t*i		// z is twice t	//	//  run				// plots t in red and z in orange on the complex plane. 	//					// t may be dragged between 0 and 1	//					// z moves between 0 and 2*i accordingly 	//	// Variables	static public var state:IState;		// Expression Types in precedence order	static public const CONSTANT:Number = 1;	static public const VARIABLE:Number = 2;	static public const UNARY:Number = 3;	static public const BINARY:Number = 4;//	static public const DEFINITION:Number = 5;	static public const RELATION:Number = 6;	static public const SET:Number = 7;	static public const COMMAND:Number = 8;		// Operator precedence table	static public const precedence:Object = {		equals:0,		greaterThan:1,		lessThan:1,		greaterEquals:1,		lessEquals:1,		union:2,		plus:3,		minus:3,		times:4,		over:4,		negate:5,		real:5,		complex:5,		conjugate:5,		pow:6,		pi:7,		e:7	};		// Expression state	private var _type:Number;	private var _name:String;	// of a constant, variable or operator or function; otherwise null	private var _value:Complex;	// of a constant	private var _expr0: Expression; // first component of UNARY or BINARY Expression	private var _expr1: Expression; // second component of BINARY Expression		public var constraints: Array; // Array of constraints	public var colour: Number;	// Some error conditions	public const BADSET:String = "BadSetSyntax";	public const EXPECTOPENER:String = "NoOpener";	public const ENDEXPR:String ="EndExpression";		public function get type():Number	{		return _type;	}	public function set type(t:Number):void	{		_type = t;	}		public function get name():String	{		return _name;	}	public function set name(s:String):void	{		_name = s;	}		public function get value():Complex	{		return _value;	}	public function set value(c:Complex):void	{		_value = c;	}		public function get real():Number	{		return _value.x;	}	public function set real(r:Number):void	{		_value = new Complex(r, 0);	}		public function get expr0():Expression	{		return _expr0;	}	public function set expr0(e:Expression):void	{		_expr0 = e;		}		public function get expr1():Expression	{		return _expr1;	}	public function set expr1(e:Expression):void	{		_expr1 = e;	}		public static const differential:Object = {		sin:"cos(z)",		cos:"-sin(z)",		sinh:"cosh(z)",		cosh:"sinh(z)",		tan:"1/(cos(z)^2)",		tanh:"1/(cosh(z)^2)",		reciprocal:"-1/(z^2)",		exp:"exp(z)",		negate:"negate(z)",		conjugate:null,		abs:null,		arg:"1/(i*z)",		ln:"1/z",		sqr:"2*z",		sqrt:"-1/sqrt(z)",		acos:"-1/sqrt(1-z^2)",		asin:"1/sqrt(1-z^2)",		acosh:"1/sqrt(z^2-1)",		asinh:"1/sqrt(z^2+1)",		atan:"1/(1+z^2)",		atanh:"1/(1-z^2)"	};	/**	 * <p>	 * Construct an Expression from an object. If the object is null, a Number, or a Complex number	 * then a constant expression is produced. String objects are parsed according to the grammar. 	 * All other objects	 * </p>	 * @param s the object from which to construct the expression	 * 	 */	function Expression(s:Object) {		if(s == null) {			type = CONSTANT;			value = null;		}		if(s is Number || s is int || s is uint) {			type = CONSTANT;			name = "real";			value = new Complex(s as Number);		}		else if(s is Complex) {			type = CONSTANT;			name = "complex";			value = Complex(s);		}		else if(s is String) {			instr = s as String;			instrx = 0;			parse();		}		else {			type = s.type;			name = s.name;			value = s.value;			expr0 = s.expr0;			expr1 = s.expr1;		}		//simplifyInPlace();	}		public function clone():Expression {		return new Expression({type:type, name:name, value:value, expr0:expr0, expr1:expr1});	}									 	public function get displayName():String {		switch(name) {			case "real": return value.displayString();			case "complex": return value.displayString();			case "pi": return value.displayString();			case "e": return value.displayString();			case "equals": return '==';			case "greaterThan": return ">";			case "lessThan": return "<";			case "greaterEquals": return ">=";			case "lessEquals": return "<=";			case "plus": return '+';			case "minus": return '-';			case "negate": return '-';			case "positive": return '+';			case "times":return '*';			case "over":return '/'			case "conjugate": return '~';			case "union":return ',';			case "pow":return '^';			default:				return name;		}	}		public function isDefinition():Boolean {		return type == COMMAND && name == "assignValue";	}		public function isVariable():Boolean {		return type == VARIABLE;	}		public function isSymConst():Boolean {		return name=="i" ||  name == "pi" || name == "e";	}		public function isConstant():Boolean {		return type == CONSTANT;	}		public function isConstraint():Boolean {		return type == RELATION;	}		public function isCommand():Boolean {		return type == COMMAND;	}		public function substitute(varName:String, e:Expression):Expression {		// 		// Substitute VARIABLE varName with the new expression as many times as varName occurs,		// returning a deep copy of the expression		//		var rv:Expression = clone();		switch(type) {			case CONSTANT:				return rv;						case VARIABLE:				return (name == varName) ? e : rv;						case UNARY:				rv.expr0 = expr0.substitute(varName,e);				return rv;						case BINARY:			case RELATION:			case SET:			case COMMAND:				rv.expr0 = expr0.substitute(varName,e);				rv.expr1 = expr1.substitute(varName,e);				return rv;							default:				throw new Error("undefined type on substitute(): " + type) 						}	}		public function evaluate(substituteVars:Boolean = true):Complex {		//		// Evaluate the expression at z		//		var w:Complex=null;		switch(type) {			case CONSTANT:				return value;						case VARIABLE:				//trace("type = VARIABLE; var = " + value + " value = " + variables[value.toString()]);				if(substituteVars) {					w = state.getValue(name);					//trace("Expression 210: subsituting for " + name + "=" + w); 				}				return (w==null) ? new Complex(name) : w;			case UNARY:				if(expr0) {				    w = expr0.evaluate(); 					return w[name].call(w);				}				return null;							case BINARY:				if(expr0 && expr1) {				    w = expr0.evaluate();					return w[name].call(w, expr1.evaluate());				}				return null;/*			case DEFINITION:				w = expr0.evaluate();				//trace("Expression:200: w=" + w);				variables[name]=w;				return w;*/							case RELATION:				if(expr0 && expr1) {					w = expr0.evaluate();					return w[name].call(w, expr1.evaluate());				}				return null;							case SET:				//trace("Expression 232: evaluating setvalue: expr0="+expr0+" expr1="+expr1);				if(expr0 == null) {					// it's the empty set					// trace("Expression:202: empty set evaluation");					return new Complex(new SetValue({}));				}				if(expr1 == null) {					// it's a single element set					// trace("Expression:205: single element set");					var member:String = expr0.toString();					var members:Object = {};					members[member]=expr0.evaluate(substituteVars);					return new Complex(new SetValue(members));				}				// it's a set with at least 2 members				w = expr0.evaluate(substituteVars);				return w[name].call(w, expr1.evaluate(substituteVars));							case COMMAND:				return state.executeCommand(name, expr0.name, expr1);			default:				throw new Error("undefined type on evaluate(): " + type) 		}	}		private function equalsZero():Boolean {		return type==CONSTANT && value.x==0 && value.y==0;	}		private function equalsOne():Boolean {		return type==CONSTANT && value.x==1 && value.y==0;	}		public function plus(e:Expression):Expression {		// algebraic plus with some simplification on zero		if(equalsZero())			return e;		if(e.equalsZero())			return this;		if(type==CONSTANT && e.type==CONSTANT) {			return new Expression(value.plus(e.value));		}		return new Expression({type:BINARY, name:"plus", expr0:clone(), expr1:e});	}		public function minus(e:Expression):Expression {		// algebraic minus with some simplifications		if(e.equalsZero())			return clone();		if(e.type==UNARY && e.name=="negate") {			e = e.expr0;		}		else {			if(e.type==CONSTANT) {				e.value = e.value.negate();				//e.name = "-"+e.name;			}			else {				e = new Expression({type:UNARY, name:"negate", expr0:e});			}		}		return plus(e);	}		public function times(e:Expression):Expression {		// algebraic times with some simplification on zero and one		if(equalsZero() || e.equalsOne())			return clone();		if(e.equalsZero() || equalsOne())			return e;		if(type==CONSTANT && e.type==CONSTANT) {			return new Expression(value.times(e.value));		}		return new Expression({type:BINARY, name:"times", expr0:clone(), expr1:e});	}		public function over(e:Expression):Expression {		if(equalsZero() || e.equalsOne())			return clone();		if(type==CONSTANT && e.type==CONSTANT) {			return new Expression(value.over(e.value));		}		return new Expression({type:BINARY, name:"over", expr0:clone(), expr1:e});	}		public function ln():Expression {		if(equalsOne())			return new Expression(0);		return new Expression({type:UNARY, name:"ln", expr0:clone()});	}		public function exp():Expression {		if(equalsZero())			return new Expression(1);		if(equalsOne())			return new Expression({type:CONSTANT, name:"e", value:new Complex(Math.E)});		return new Expression({type:UNARY, name:"exp", expr0:clone()});	}		public function pow(e:Expression):Expression {		if(e.equalsOne())			return clone();		if(equalsOne() || e.equalsZero())			return new Expression(1);		return new Expression({type:BINARY, name:"pow", expr0:clone(), expr1:e});	}			public function differentiate(z:String):Expression {		//		// Differentiate expression with respect to Expression z		//		var zero:Expression = new Expression(0);		var one:Expression = new Expression(1);		var gDashed:Expression;		var hDashed:Expression;		switch(type) {			case CONSTANT:				return zero; //new Expression(0);						case VARIABLE:				if(name == z)					return one; //new Expression(1);				else					return zero; //new Expression(0);			case UNARY:				if(expr0 == null) return null;				// chain rule:				// (f(g(z))' = f'(g(z))*g'(z)				//				gDashed = expr0.differentiate(z);				// lookup differential of unary f and parse from string as f(z)				var fDashed:Expression = new Expression(differential[name]);				return fDashed.substitute("z", expr0).times(gDashed);							case BINARY:				if(expr0 == null || expr1 == null) return null;				switch(name) {										case "plus":						return expr0.differentiate(z).plus(expr1.differentiate(z));											case "minus":						return expr0.differentiate(z).minus(expr1.differentiate(z));					case "times":						return expr0.times(expr1.differentiate(z)).plus(expr1.times(expr0.differentiate(z)));					case "over":						var numerator:Expression = expr1.times(expr0.differentiate(z)).minus(expr0.times(expr1.differentiate(z)));						var denominator:Expression = new Expression({type:UNARY, name:"sqr", expr0:expr1});						return numerator.over(denominator);					case "pow":						// 						// f = g^h						// => f' = (h'*ln(g) + h*g'/g)*g^h						//						//trace("expr0="+expr0+" expr1="+expr1);						gDashed = expr0.differentiate(z);						hDashed = expr1.differentiate(z);						//trace("hDashed = " + hDashed);						if(gDashed.equalsOne() && hDashed.equalsZero()) {							return expr1.times(gDashed.times(expr0.pow(expr1.minus(one))));						}						var t0:Expression = hDashed.times(expr0.ln());						var t1:Expression = expr1.times(gDashed).over(expr0);						return t0.plus(t1).times(expr0.pow(expr1));					default:						throw new Error("Unknown BINARY on differentiate: " + name);				}						case RELATION:				throw new Error("Cannot differentiate a relation");							case SET:				throw new Error("Cannot differentiate a set");							case COMMAND:				throw new Error("Cannot differentiate a command");							default:				throw new Error("undefined type on differentiate(): " + type) 		}	}		public function mainVariable():Expression {		switch(type) {			case CONSTANT:				return null;			case VARIABLE://			case DEFINITION:				return this;			case UNARY:				if(expr0 == null) return null;				return expr0.mainVariable();			case BINARY:			case RELATION:				if(expr0 == null || expr1 == null) return null;				var e:Expression = expr0.mainVariable();				return (e == null) ? expr1.mainVariable() : e;			case SET:				return null;			case COMMAND:				//trace("Expression:268: mainVariable expr0="+expr0);				return expr0.mainVariable();			default:				throw new Error("Undefined type on mainVariable(): " + type);		}		}		// 	// Call the callback function for every variable we depend on.	// Used to set up variable update chains.	//	public function callDependencies(scope:Object, callback:Function, subject:Object):void {		switch(type) {			case CONSTANT:				return;			case VARIABLE:				callback.call(scope, subject, this); // definition depends on this				return;			/*			case DEFINITION:				expr0.callDependencies(scope, callback, subject);				return;			*/			case UNARY:				if(expr0 == null) return;				expr0.callDependencies(scope, callback, subject);				return;			case BINARY:			case RELATION:			case SET:				if(expr0 == null || expr1 == null) return;				if(expr0!= null) {					expr0.callDependencies(scope, callback, subject);					if(expr1!=null) {						expr1.callDependencies(scope, callback, subject);					}				}				return;			case COMMAND:				if(name=="assignValue") {					expr1.callDependencies(scope, callback, subject);					return;				}				else {					throw new Error("callDependencies on command:"+name);				}			default:				throw new Error("Undefined type on callDependencies(): " + type);		}	}		public function isFreePoint():Boolean {		switch(type) {			case CONSTANT:				return true;			case VARIABLE:				return false;			//case DEFINITION:			case UNARY:				if(expr0 == null) return false;				return expr0.isFreePoint();			case BINARY:				if(expr0 == null || expr1 == null) return false;				return expr0.isFreePoint() && expr1.isFreePoint();			case RELATION:				return false;			case SET:				return false;			case COMMAND:				if(name=="assignValue") {					//trace("Expression:333 expr0.type="+expr0.type);					if(expr1 == null) return false;					return expr1.isFreePoint();				}				return false;			default:				throw new Error("Undefined type on isFreePoint(): " + type);		}	}		public function addConstraint(c:Expression):void {		if(constraints == null) {			constraints = [c];		}		else {			constraints.push(c);		}	}/*	function simplify():Expression {		switch(type) {			case CONSTANT:				return this;			case VARIABLE:				return this;			case UNARY:				if(expr0.type == CONSTANT) {					return new Expression({type:CONSTANT, value:evaluate()});				}				else {					return new Expression({type:type, name:name, expr0:expr0.simplify()})				}				break;			case BINARY:				if(expr0.type == CONSTANT && expr1.type == CONSTANT) {					return new Expression({type:CONSTANT, value:evaluate()});				}				else {					return new Expression({type:type, name:name, expr0:expr0.simplify(), expr1:expr1.simplify()})				}		}	}*/		public function simplifyInPlace():void {		switch(type) {			case CONSTANT:				return;			case VARIABLE:				return;			case UNARY:				if(expr0 == null) return;				if(expr0.type == CONSTANT) {					value = evaluate();					type = CONSTANT;					name = expr0.name;					return; //new Expression({type:CONSTANT, value:evaluate()});				}				else {					expr0.simplifyInPlace();					return;					//return new Expression({type:type, name:name, value:expr0.simplify()})				}				break;			case BINARY:			case RELATION:			case SET:				if(expr0 == null || expr1 == null) return;			/*				if(expr0.type == CONSTANT && expr1.type == CONSTANT) {					value = evaluate();					type = CONSTANT;					name = (expr0.name == "real" && expr1.name == "real") ? "real" : "complex";					return;				}				else 				{ 					if(expr0 != null) {						expr0.simplifyInPlace();						if(expr1 != null) {							expr1.simplifyInPlace();						}					}					return;				}/*			case DEFINITION:				expr0.simplifyInPlace();*/			case COMMAND:				if(expr1 == null) return;				expr1.simplifyInPlace();		}	}/*	//	// Return the inverse of this expression. Note that this requires all expressions to be	// simplifiedInPlace first. This is a bit of a kludge and we probably should avoid using	// it.	//	function invert(z:Expression, variable:String):Expression {		if(z == null) {			z = new Expression({type:VARIABLE, value:(variable == null ? "f" : variable)});		}		switch(type) {			case CONSTANT:				return null;							case VARIABLE:				return z;							case UNARY:				z = new Expression({type:type, name:Complex.inverse[name], expr0:z});				return expr0.invert(z); //expr0.type == UNARY ? expr0.invert(z) : z;							case BINARY:				//trace("invert " + type + " not implemented") 				//return this;				if(expr0.type == CONSTANT) {					var e:Expression = expr0;					expr0 = expr1;					expr1 = e;				}				var unop:String = (name == "plus") ? "negate" : "reciprocal";				var w:Expression = new Expression({type:UNARY, name:unop, expr0:expr1});				z = new Expression({type:type, name:name, expr0:z, expr1:w});				return expr0.invert(z);							default:				trace("undefined type on evaluate(): " + type) 		}	}*/	public function toString():String {		switch(type) {			case CONSTANT:				if(name == "real" || name == "complex" || isSymConst())					return value.toString();				return name;			case VARIABLE:				return name // value.toString();;							case UNARY:				if(expr0 == null) return "null";				return name + "(" +expr0 + ")";							case BINARY:			case RELATION:				if(expr0 == null || expr1 == null) return "null";				return "(" + expr0 + " " + name + " " + expr1 + ")";/*							case DEFINITION:				return name + " := " + expr0;*/							case SET:				//return '{' + expr0.toList() +", " + expr1.toList() + "}";				if(expr0 == null || expr1 == null) return "null";				if(expr0 == null) {					return "{}";				}				if(expr1 == null) {					return "{" + expr0.toList() + "}";				}				return '{' + expr0.toList() +" U " + expr1.toList() + "}"; 			case COMMAND:				if(expr0 == null || expr1 == null) return "null";				return expr0 + " " + state.commandDisplayName(name) + " " + expr1;			default:				throw new Error("undefined type on Expression.toString() " + type) 		}	}		public function toList():String {		if(type != SET) {			return '{' + this + '}'; 		}		return this.toString();	}		private function ptrace(msg:String, rv:Boolean):void {		trace(msg + " = " + rv); 	}		private function higherPrec(e:Expression):Boolean {		var rv:Boolean;		if(type == UNARY) {			if(name=="negate" || name == "conjugate" || name == "logicalNot") {				rv = (type < e.type);				//ptrace("UNARY "+name+" types "+e.type + ">" + type, rv);				return rv;			}			rv = true;			//ptrace("UNARY "+name, rv);			return rv;		}		if(type != e.type) {			rv = (type < e.type);			//ptrace("types " + type + " " + e.type, rv);			return rv;		}		/*		if(type == BINARY && name=="pow") {			rv = true;			ptrace("BINARY pow", rv);			return rv;		}		*/		rv = (precedence[name] > precedence[e.name]);		//ptrace("names "+name+" > "+e.name, rv);		return rv;	}		private function wrap(e:Expression):String {		if(higherPrec(e))			return "(" + e.displayString() + ")";		else			return e.displayString();	}		public function displayString():String {		//		// TEST: that parser accepts the emitted syntax		//		switch(type) {			case CONSTANT:				//trace(displayName + " is named " + name);				if(name == "real" || name == "complex" || isSymConst())					return value.displayString();				return name;				//return value.displayString();			case VARIABLE:				//trace(displayName + " is named " + name);				return name // value.toString();;							case UNARY:				//trace(displayName + " is named " + name);				if(expr0 == null) return "null";				return displayName + wrap(expr0);							case BINARY:			case RELATION:				//trace(displayName + " is named " + name);				if(expr0 == null || expr1 == null) return "null";				return wrap(expr0) + displayName + wrap(expr1);			case SET:				//return toString();				return evaluate(false).toString(); 						case COMMAND:				if(expr0 == null || expr1 == null) return "null";				var s:String = wrap(expr0) + " " + state.commandDisplayName(name) + " " + wrap(expr1);				return s;							default:				throw new Error("undefined type on Expression.displayString() " + type) 		}	}		private function end(o:Object):Object {		if(o == null) return "end";		return o;	}	//------------------------------------------------------------------------------------		// Lexical tokens	public static const COMMA:Number = 12;	public static const EQUALS:Number = 11;	public static const RELOP:Number = 10;	public static const ADDOP:Number = 9;	public static const MULOP:Number = 8;	public static const CFUNC2:Number = 7;	public static const CFUNC1:Number = 6;	public static const POWOP:Number = 5;	public static const OPEN:Number = 4;	public static const CLOSE:Number = 3;	public static const NUMBER:Number = 2;	public static const SYMBOL:Number = 1;	//static var COMMAND1:Number = 13;	//	// Recursive descent complex expression parser 	//	public function parse():void {		//		// Rule: START -> Expression		//		try {			copy(expectExpression());		}		catch (err:Error) {			//trace(err.getStackTrace());			throw new Error("Syntax error: " + err);		}	}		public function copy(e:Expression):void {		if(e == null) {			throw new Error(" null Expression");		}		type = e.type;		name = e.name;		value = e.value;		expr0 = e.expr0;		expr1 = e.expr1;	}	public function relop2Relation(relop:String):String {		switch(relop) {			case ">": return "greaterThan";			case ">=": return "greaterEquals";			case "<": return "lessThan";			case "<=": return "lessEquals";			case "==": return "equals";			case "!=": return "notEquals";			default:				throw new Error("unknown relop: "+relop);		}	}			private function expectExpression():Expression {	// Expression -> Command ( parameters* )	//			  |  RTerm	//            |  LTerm SYMBOL RTerm  // a command	//			;	//	// Lterm -> Symbol	//			;		var token:Object = getToken();		var t1:Expression;		//		// Command SExpression* // immediate command		//		if(token != null) {			if(token.name==SYMBOL && state.hasCommand(token.value)) {				//trace("command "+token.value);				var param:Expression;				try {					param = expectSExpression("(");					return new Expression({type:COMMAND, name:token.value, expr0:param});				}				catch(err:Error) {					if(err.name == EXPECTOPENER) {						return new Expression({type:COMMAND, name:token.value, expr0:null});					}					trace("ignoring Error: "+err);				}					}					//			// LTerm Command RTerm //was: LTerm EQUALS  Expression			//			if(token.name == SYMBOL) {				t1 = new Expression({type:VARIABLE, name:token.value});				var t2:Expression;				var token2:Object = getToken();				if(token2!= null && token2.name==SYMBOL && state.hasCommand(token2.value)) {					try {						t2 = expectRTerm();					}					catch(err:Error) {												if(err.name == ENDEXPR) {						  return new Expression({type:COMMAND, name:token2.value, expr0:t1, expr1:null});						}					}					return new Expression({type:COMMAND, name:token2.value, expr0:t1, expr1:t2});				}				putToken(token2);			}		}		putToken(token);		t1 = expectRTerm();		return t1;	}	private function expectRTerm():Expression {	// RTerm -> CExpression | SExpression	//			;	//		var t1:Expression;		try {			t1 = expectSExpression("{");		}		catch(err:Error) {			if(err.name == BADSET) {				trace("throwing BADSET");				throw err;			}			//try {				t1 = expectCExpression();			/*			}			catch(err) {				throw("Expected CExpression: "+err);			}			*/		}		return t1;	}	private function expectCExpression():Expression {		//		// Rule: CExpression -> Additive (RELOP Additive)?		//                   ;		//		var t1:Expression = expectAdditive();		var token:Object = getToken();						if(token != null && token.name == RELOP) {			var t2:Expression = expectAdditive();			var e:Expression = new Expression({type:RELATION, name:relop2Relation(token.value), expr0:t1, expr1:t2});			//			// TODO: Sort out how we want to use constraints. 			// [e.g. 			//		to constrain t between -1 and +1 on the real axis			//		to constrain t inside the unit circle ]			//			// Following needs changing so the constraint applies to all defined variables			// that it affects. Need a way to remove constraints too.			//			var m:Expression = e.mainVariable();			if(m != null) {				m.addConstraint(e);			}			return e;		}		putToken(token);		return t1;	}		private function expectAdditive():Expression {		// 		// Rule: Additive -> Term (ADDOP Term)*		//				;		var t1:Expression = expectTerm();		var token:Object;		while((token = getToken()) != null) {			if(token.name != ADDOP) {				putToken(token);				break;			}			var t2:Object = expectTerm();			t1 =  new Expression({type:BINARY, name:token.value, expr0:t1, expr1:t2}); 		}		return t1;	}		private function getCloser(opener:String):String {		switch(opener) {			case "(": return ")";			case "{": return "}";			case "[": return "]";			default: return null;		}	}		private function expectSExpression(opener:String):Expression {		//		// Rule: SExpression -> '{' (CExpression (COMMA CExpression)*)? '}'		//				      ;		//		var token:Object = getToken();		var closer:String = (opener==null || token.value == opener) ? getCloser(token.value) : null;		if(token != null && token.name == OPEN && closer != null) {			var s:Expression = new Expression({type:SET, expr0:null, expr1:null});			var t1:Expression = null;			try {				t1 = expectCExpression();				//trace("CExpression after (");			} catch(err:Error) {				// Check for an empty set...				var token2:Object = getToken();				if(token2 == null || token2.value != closer) {					putToken(token2);					err.name = BADSET;//"UnrecognisedSet";					err.message = " Expected Expression or "+closer+ " at " + end(token2.pos) + " got " +token.value+" "+ token2.value;					throw err;				}				return s;			}			//trace("Expression:717: t1 = "+t1);			while((token = getToken()) != null) {				if(token.name != COMMA) {					putToken(token);					break;				}				var t2:Object = expectCExpression();				//trace("Expression:724: t2 = "+t2);				t1 =  new Expression({type:SET, name:'union', expr0:t1, expr1:t2}); 			}			var tok2:Object = getToken();			if(tok2 == null || tok2.value != closer) {				putToken(tok2);				throw new Error("Expected " + closer + " at " + end(tok2.pos) + " got " + token.value + " " + tok2.value);			}			return t1.type == SET ? t1 : new Expression({type:SET, expr0:t1, expr1:null});;				}		putToken(token);		var err:Error = new Error("Expected "+ opener + " at " + end(token.pos));		err.name = EXPECTOPENER;		throw err;		//return null;	}		public function expectTerm():Expression {		//		// Rule: Term -> Factor (MULOP Factor)*		//		var f1:Expression = expectFactor();		var token:Object;		while((token = getToken()) != null) {			var op:String = token.value;			if(token.name != MULOP) {				putToken(token);				break;			}			var f2:Object;			try {				f2 = expectFactor();			}			catch(err:Error) {				putToken(token);				throw new Error("Expected Factor at: " + end(token.pos));			}			f1 = new Expression({type:BINARY, name:token.value, expr0:f1, expr1:f2});					}		return f1  	}		public function expectFactor():Expression {		//		// Rule: Factor -> ADDOP Factor | Power		//		var token:Object = getToken();		if(token != null && token.name == ADDOP) {			var f1:Expression = expectFactor();			if(token.value == "minus") {				//trace("f1.type = " + f1.type);				if(f1.type==CONSTANT) {					f1.value = f1.value.negate();					return f1;				}				return new Expression({type:UNARY, name:"negate", expr0:f1})			}			else {				return f1;			}		}		putToken(token);		return expectPower();	}		private function expectPower():Expression {		//		// Rule: Power -> Atom (POWOP Factor)?		//		var a1:Expression = expectAtom();		var token:Object = getToken();		if(token != null && token.name == POWOP) {			var f1:Expression = expectFactor();			return new Expression({type:BINARY, name:token.value, expr0:a1, expr1:f1})		}		putToken(token);		return a1;	}		private function expectAtom():Expression {		//		// Rule: Atom ->  '(' Expression ')' | Number | Symbol | Function		//		var token:Object = getToken();		if(token != null) {			if(token.name == OPEN) {				var e1:Expression = expectCExpression();  // was expectCExpression, but that did not admit relativeExpressions				var token2:Object = getToken();				if(token2 == null || token2.name != CLOSE) {					var msg:String = "expected closing bracket";					if(token2==null)						throw new Error(msg);					else 						throw new Error(msg + " at " + end(token2.pos));				}				return e1;			}			if(token.name == NUMBER) {				return new Expression({type:CONSTANT, name:"real", value:(new Complex(token.value))});			}			if(token.name == SYMBOL) {				if(token.value == "i") {					return new Expression({type:CONSTANT, name:"i", value:(new Complex(0,1))});				}				if(token.value == "pi") {					return new Expression({type:CONSTANT, name:"pi", value:(new Complex(Math.PI))});				}				if(token.value == "e") {					return new Expression({type:CONSTANT, name:"e", value:(new Complex(Math.E))});				}				return new Expression({type:VARIABLE, name:token.value});				//return new Expression({type:VARIABLE, value:token.value});			}			putToken(token);		}		return expectFunction();	}		private function expectFunction():Expression {		//		// Rule: Function -> CFUNC1 Atom 		//				  | CFUNC2 '(' Expression ',' Expression ')' 		//       ;		//		var token:Object = getToken();		if(token != null) {			switch(token.name) {				case CFUNC1:					var a1:Expression = expectAtom();					return new Expression({type:UNARY, name:token.value, expr0:a1});				case CFUNC2:					var token1:Object = getToken();					var e:Expression;					var t:Expression;					if(token1.name == OPEN) {						var e1:Expression = expectCExpression();						token1 = getToken();						if(token1 == null || token1.name != COMMA) {							throw new Error("expected comma at " + end(token1.pos));						}						var e2:Expression = expectCExpression();						token1 = getToken();						if(token1 == null || token1.name != CLOSE) {							throw new Error("expected ')' at " + end(token1.pos));						}						switch(token.value) {							case "plus":							case "times":								return new Expression({type:BINARY, name:token.value, expr0:e1, expr1:e2});							case "minus":								e = new Expression({type:UNARY, name:"negate", expr0:e2});								return new Expression({type:BINARY, name:"plus", expr0:e1, expr1:e});							case "over":								//trace("***** OVER ******");								e = new Expression({type:UNARY, name:"reciprocal", expr0:e2});								return new Expression({type:BINARY, name:"times", expr0:e1, expr1:e});							case "pow":								// = exp(e2*ln(e1))								e = new Expression({type:UNARY, name:"ln", expr0:e1});								t = new Expression({type:BINARY, name:"times", expr0:e2, expr1:e});								return new Expression({type:UNARY, name:"exp", expr0:t});						}						//return new Expression({type:BINARY, name:token.value, expr0:e1, expr1:e2});					}				default:					// null return is needed to get close with the MULOP? variant					/*					return null;					*/					putToken(token);					if(token.pos==null) {						var err:Error = new Error("end of expression");						err.name = ENDEXPR;						throw err;					}					throw new Error("expected function at " + end(token.pos) + " token = " + token.name);			}		}		throw new Error("expected function at end of expression");	}	//------------------------------------------------------------------------------------		//	// Lexical analyser from here	//	// Lexical state	private var instr:String;	private var instrx:Number;	private var char:String;	private var charx:Number;	private var backtrack:Array;		private function putToken(token:Object):void {		if(token != null && !isNaN(token.pos)) {			instrx = token.pos;		}	}		private function getToken():Object {		/*		if(backtrack == null) {			backtrack = [];		}		var token:Object = backtrack.pop();		if(token != null) {			return token;		}		*/		var c:String;		var pos:Number = instrx;		if((c = getc()) == "") return null;					switch(c) {			case "+":				return {name:ADDOP, value:"plus", pos:pos};			case "-":				return {name:ADDOP, value:"minus", pos:pos};			case "*" :				return {name:MULOP, value:"times", pos:pos};			case "/" :				return {name:MULOP, value:"over", pos:pos};			case "^" :				return {name:POWOP, value:"pow", pos:pos};			case "~" : 				return {name:CFUNC1, value:"conjugate", pos:pos};			case "(" :			case "{" :			case "[" :				return {name:OPEN, value:c, pos:pos};			case ")" :			case "}" :			case "]" :				return {name:CLOSE, value:c, pos:pos};			case "," :				return {name:COMMA, value:c, pos:pos};			case "=" :				if((c = getc()) == "=") {					return {name:RELOP, value:"==", pos:pos};				}				else {					ungetc(c);					return {name:SYMBOL, value:"assignValue", pos:pos};					//return {name:EQUALS, value:"=", pos:pos};				}			case "!" :				if((c = getc()) == "=") {					return {name:RELOP, value:"!=", pos:pos};				}				else {					ungetc(c);					return {name:CFUNC1, value:"logicalNot", pos:pos};				}			case ">" :				if((c = getc()) == "=") {					//trace("GREATER THAN OR EQUALS");					return {name:RELOP, value:">=", pos:pos};				}				else {					ungetc(c);					return {name:RELOP, value:">", pos:pos};				}			case "<" :				if((c = getc()) == "=") {					return {name:RELOP, value:"<=", pos:pos};				}				else {					ungetc(c);					return {name:RELOP, value:"<", pos:pos};				}		}		//		// Scan for possible number		//		if(isnum(c)) {			var n:Number;			instrx--;			for(var j:int = 1; instrx+j <= instr.length; j++) {				var sub:String = instr.substr(instrx, j);				var m:Number = Number(sub);				if(isNaN(m)) {					// Check for a possible '0x' opening to a hexadecimal number					var sub2:String = instr.substr(instrx,j+1);					if(!isNaN(Number(sub2))) {						continue;					}					//trace("substring " + sub + " is not a number");					break;				}				n = m;			}			instrx += (j-1);			return {name:NUMBER, value:n, pos:pos};		}		if(isalpha(c)) {			var s:String = c;						while((isalpha(c = instr.charAt(instrx)) || isnum(c)) && instrx < instr.length) {				s += c;				instrx++;			}						// check for constant value of i			switch(s) {				case "i":					return {name:SYMBOL, value:"i", pos:pos};				case "pi":					return {name:SYMBOL, value:"pi", pos:pos};				case "e":					return {name:SYMBOL, value:"e", pos:pos};				case "pow":					return {name:CFUNC2, value:s, pos:pos};			}			/*			// check for some variable stored in state			var val:Complex = state.getValue(s);			if(val != null) return {name:SYMBOL, value:s, pos:pos};						// rest should be CFUNC1			if(Complex.hasFunction(s)) {				return {name:CFUNC1, value:s, pos:pos};			}			*/						// rest should be CFUNC1			if(Complex.hasFunction(s)) {				return {name:CFUNC1, value:s, pos:pos};			}						// check for some variable stored in state			return {name:SYMBOL, value:s, pos:pos};					}		return null;	}	public function getTail():String {		return instrx >= instr.length ? null : instr.substr(instrx);	}		private function tokenToString(token:Object):String {		return "" + token.value;	}			private function isnum(c:String):Boolean {		return (c >= "0" && c <= "9");	}	private function isalpha(c:String):Boolean {		return (c >= "a" && c <= "z") || (c >= "A" && c <= "Z");	}		private function isspace(c:String):Boolean {		return c == " " || c == "\t" || c == "\n" || c == "\r";	}		private function getc():String {		var c:String;		charx = instrx;		//if(c == null) {			while(isspace(c = instr.charAt(instrx++))) {				if(instrx >= instr.length) {					return null;				}			}		//}		//char = null;		return c;	}		private function ungetc(c:String):void {		//char = c;		instrx = charx;	}	}}