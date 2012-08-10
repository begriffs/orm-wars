from sqlalchemy import *
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, scoped_session

engine = create_engine('postgresql://localhost/sqlalchemy_test', echo=True)
Base = declarative_base(bind=engine)
Session = scoped_session(sessionmaker(engine))

class User(Base):
  __tablename__ = 'users'
  id = Column(Integer, Sequence('user_id_seq'), primary_key=True)

print Session.query(User).count()
