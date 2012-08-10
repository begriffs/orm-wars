from __future__ import print_function
from sqlalchemy import *
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, scoped_session
from timeit import Timer

engine = create_engine('postgresql://localhost/sqlalchemy_test', echo=True)
Base = declarative_base(bind=engine)
Session = scoped_session(sessionmaker(engine))
session = Session()

class Group(Base):
  __tablename__ = 'groups'
  id = Column(Integer, Sequence('group_id_seq'), primary_key=True)

class User(Base):
  __tablename__ = 'users'
  id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
  group_id = Column(Integer, ForeignKey('groups.id'))

def dream(name, action):
  session.begin(subtransactions=True)
  print("#"*80)
  print("### Dreaming of %s" % (name))
  t = Timer(action)
  print("### Time elapsed %f" % (t.timeit(number=1)))
  print("#"*80 + "\n\n\n")
  session.rollback()

for _ in range(3):
  session.add(Group())
session.flush()

dream('counting groups', lambda: print(session.query(Group).count()))

session.rollback()
