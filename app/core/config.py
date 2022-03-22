import os
from typing import Optional, Dict, Any
from pydantic import BaseSettings, PostgresDsn, validator
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseSettings):
    POSTGRES_SERVER: str = os.environ.get("POSTGRES_SERVER", "devel.c4r2muiz9fkl.ap-northeast-2.rds.amazonaws.com:5432"),
    POSTGRES_USER: str = os.environ.get("POSTGRES_USER", "hzdevel")
    POSTGRES_PASSWORD: str = os.environ.get("POSTGRES_PASSWORD", "roqkfgowna12#$")
    POSTGRES_DB: str = os.environ.get("POSTGRES_DB", "test_hyunlang")
    DB_ECHO: bool = True
    SQLALCHEMY_DATABASE_URI: Optional[PostgresDsn] = None

    @validator("SQLALCHEMY_DATABASE_URI", pre=True)
    def assemble_db_connection(cls, v: Optional[str], values: Dict[str, Any]) -> Any:
        print('assemble_db_connection.v : ', v)
        print('assemble_db_connection.values : ', values)
        if isinstance(v, str):
            return v
        return PostgresDsn.build(
            scheme="postgresql",
            user=values.get("POSTGRES_USER"),
            password=values.get("POSTGRES_PASSWORD"),
            host= values.get("POSTGRES_SERVER"), #type:ignore
            path=f"/{values.get('POSTGRES_DB') or ''}",
        )



settings = Settings()
