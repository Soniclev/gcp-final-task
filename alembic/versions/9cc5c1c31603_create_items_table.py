"""create items table

Revision ID: 9cc5c1c31603
Revises: dd60c33628db
Create Date: 2022-11-10 15:28:34.810379

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '9cc5c1c31603'
down_revision = 'dd60c33628db'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        'items',
        sa.Column('id', sa.Integer, primary_key=True, index=True),
        sa.Column('title', sa.String, index=True),
        sa.Column('description', sa.String, index=True),
        sa.Column('owner_id', sa.Integer, sa.ForeignKey("users.id")),
    )


def downgrade() -> None:
    op.drop_table('items')
