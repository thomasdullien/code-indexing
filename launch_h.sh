docker run\
        --net h_default\
        -e "APP_URL=http://localhost:5000"\
        -e "AUTHORITY=localhost"\
        -e "BROKER_URL=amqp://guest:guest@rabbit:5672//"\
        -e "DATABASE_URL=postgresql://postgres@postgres/postgres"\
        -e "ELASTICSEARCH_URL=http://elasticsearch:9200"\
        -e "SECRET_KEY=notasecret"\
        -e "CLIENT_URL=http://35.196.26.228:5000/static/data/hypothesis/boot.js"\
        -e "CLIENT_OAUTH_ID=2458f510-a886-11e8-98c9-9b460f570619"\
        --mount type=bind,source=/home/thomas_dullien/indexed_sources,target=/data_to_serve,readonly\
        -p 5000:5000\
        00d8f27aeba9
