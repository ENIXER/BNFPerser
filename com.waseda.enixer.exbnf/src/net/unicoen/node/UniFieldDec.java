package net.unicoen.node;

import java.util.List;

public class UniFieldDec extends UniMemberDec {
	public List<String> modifiers;
	public String type;
	public String name;
	public UniExpr value;

	public UniFieldDec() {
	}

	public UniFieldDec(List<String> modifiers, String type, String name, UniExpr value) {
		this.modifiers = modifiers;
		this.type = type;
		this.name = name;
		this.value = value;
	}

	@Override
	public String toString() {
		return "FieldDec(" + type + ", " + name + ")";
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == null || !(obj instanceof UniFieldDec)) return false;
		UniFieldDec that = (UniFieldDec)obj;
		return (this.modifiers == null ? that.modifiers == null : this.modifiers.equals(that.modifiers))
			&& (this.type == null ? that.type == null : this.type.equals(that.type))
			&& (this.name == null ? that.name == null : this.name.equals(that.name))
			&& (this.value == null ? that.value == null : this.value.equals(that.value));
	}
}