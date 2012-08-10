"""create groups table

Revision ID: 3989f364dc5
Revises: 39e93e7ef50b
Create Date: 2012-08-09 21:51:30.333261

"""

# revision identifiers, used by Alembic.
revision = '3989f364dc5'
down_revision = '39e93e7ef50b'

from alembic import op
import sqlalchemy as sa
from sqlalchemy.schema import CreateSequence, DropSequence

def upgrade():
  op.execute(CreateSequence(sa.Sequence("group_id_seq")))
  op.create_table(
    'groups',
    sa.Column('id', sa.Integer, sa.Sequence('group_id_seq'), primary_key=True)
  )
  op.add_column('users',
    sa.Column('group_id', sa.Integer, sa.ForeignKey('groups.id')))

def downgrade():
  op.drop_column('users', 'group_id')
  op.drop_table('groups')
  op.execute(DropSequence(sa.Sequence("group_id_seq")))
