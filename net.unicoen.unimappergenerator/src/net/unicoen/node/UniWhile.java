package net.unicoen.node;
import net.unicoen.node_helper.*;

public class UniWhile extends UniExpr {
	public UniExpr cond;
	public UniExpr statement;

	public UniWhile() {
	}

	public UniWhile(UniExpr cond, UniExpr statement) {
		this.cond = cond;
		this.statement = statement;
	}

	@Override
	public String toString() {
		return "While";
	}

	@Override
	public int hashCode() {
		int result = 17;
		result = result * 31 + (cond == null ? 0 : cond.hashCode());
		result = result * 31 + (statement == null ? 0 : statement.hashCode());
		result = result * 31 + (comments == null ? 0 : comments.hashCode());
		result = result * 31 + (codeRange == null ? 0 : codeRange.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == null || !(obj instanceof UniWhile)) return false;
		UniWhile that = (UniWhile)obj;
		return (this.cond == null ? that.cond == null : this.cond.equals(that.cond))
			&& (this.statement == null ? that.statement == null : this.statement.equals(that.statement))
			&& (this.comments == null ? that.comments == null : this.comments.equals(that.comments))
			&& (this.codeRange == null ? that.codeRange == null : this.codeRange.equals(that.codeRange));
	}

	@Override
	public boolean isStatement() {
		return true;
	}

	public void merge(UniWhile that) {
		if (that.cond != null) {
			this.cond = that.cond;
		}
		if (that.statement != null) {
			this.statement = that.statement;
		}
		if (that.comments != null) {
			if (this.comments == null) {
				this.comments = that.comments;
			} else {
				this.comments.addAll(that.comments);
			}
		}
		if (that.codeRange != null) {
			this.codeRange = that.codeRange;
		}
	}
}
