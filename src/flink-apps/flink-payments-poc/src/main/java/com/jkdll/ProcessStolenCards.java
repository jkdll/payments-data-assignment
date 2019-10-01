package com.jkdll;

import com.amazonaws.regions.Regions;
import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kinesis.FlinkKinesisProducer;
import org.apache.flink.streaming.connectors.kinesis.config.AWSConfigConstants;
import org.apache.flink.streaming.connectors.kinesis.config.ConsumerConfigConstants;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.util.serialization.SimpleStringSchema;
import org.apache.flink.streaming.connectors.kinesis.FlinkKinesisConsumer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import java.io.IOException;
import java.util.Properties;


public class ProcessStolenCards {
    private static final Logger LOG = LoggerFactory.getLogger(ProcessStolenCards.class);
    private static final String DEFAULT_REGION_NAME = Regions.getCurrentRegion()==null ? "eu-west-1" : Regions.getCurrentRegion().getName();


    public static void main(String[] args) throws IOException {
        if(args.length < 4){
            throw new IllegalArgumentException("Wrong Number of Arguments Supplied");
        }
        final String AWS_REGION = args[0];
        final String AWS_KEY = args[1];
        final String AWS_SECRET_KEY = args[2];
        final String AWS_STREAM_NAME = args[3];

        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        Properties consumerConfig = new Properties();
        consumerConfig.put(AWSConfigConstants.AWS_REGION, AWS_REGION);
        consumerConfig.put(AWSConfigConstants.AWS_ACCESS_KEY_ID, AWS_KEY);
        consumerConfig.put(AWSConfigConstants.AWS_SECRET_ACCESS_KEY, AWS_SECRET_KEY);
        consumerConfig.put(ConsumerConfigConstants.STREAM_INITIAL_POSITION, "LATEST");


        // Producer Config
        Properties producerConfig = new Properties();
        // Required configs
        producerConfig.put(AWSConfigConstants.AWS_REGION, AWS_REGION);
        producerConfig.put(AWSConfigConstants.AWS_ACCESS_KEY_ID, AWS_KEY);
        producerConfig.put(AWSConfigConstants.AWS_SECRET_ACCESS_KEY, AWS_SECRET_KEY);

        // Kinesis Consumer
        DataStream<String> kinesis_consumer = env.addSource(new FlinkKinesisConsumer<>(AWS_STREAM_NAME, new SimpleStringSchema(), consumerConfig));
       // kinesis_consumer.timeWindowAll(Time.seconds(5));
        // Kinesis Producer
        FlinkKinesisProducer<String> kinesis_producer = new FlinkKinesisProducer<>(new SimpleStringSchema(), producerConfig);
        kinesis_producer.setFailOnError(true);
        kinesis_producer.setDefaultStream(AWS_STREAM_NAME);
        kinesis_producer.setDefaultPartition("0");

        kinesis_consumer.filter(new FilterFunction<String>() {
            @Override
            public boolean filter(String value) throws Exception {
                return value.split("\\|")[0].equals("PAYMENT_EVENT");
            }
        }).map(new StolenDetection())
                .filter(new FilterFunction<String>() {
            @Override
            public boolean filter(String value) throws Exception {
                return value != null;
            }
        }).addSink(kinesis_producer);

        try {
            env.execute();
        } catch(Exception e){
            e.printStackTrace();
        }

    }
}
