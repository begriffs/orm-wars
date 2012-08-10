"""create users table

Revision ID: 39e93e7ef50b
Revises: None
Create Date: 2012-08-09 21:33:28.187794

"""

# revision identifiers, used by Alembic.
revision = '39e93e7ef50b'
down_revision = None

from alembic import op
import sqlalchemy as sa

def upgrade():
  op.create_table(
    'users',
    sa.Column('id', sa.Integer, sa.Sequence('user_id_seq'), primary_key=True)
  )

def downgrade():
  op.drop_table('users')
