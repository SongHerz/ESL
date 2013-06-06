function testprob()
    printf("This is test 1\n");
    label_vector = [ 1; 1; 1; 0; -1];
    instance_matrix = [ 1 0 1 1 1; 1 0 1 0 0; 1 0 1 0 1; 0 0 0 0 0; 0 1 0 0 0];

    % checkprob( label_vector, instance_matrix, 10, '-s 0 -t 2 -b 1 -w1 1 -w0 3 -w-1 3 -q', '-b 1 -q');
    checkprob( label_vector, instance_matrix, 10, [], '-s 0 -t 2 -c 10 -b 1 -q', '-b 1 -q');

    printf("\n\n\nThis is test 2\n");
    label_vector = [ 1; 1; 1; -1; -1; 0];
    instance_matrix = [ 1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1; 0 0 0 0 0];
    predict_matrix = [ 1 1 0 0 0; 0 1 1 0 0; 1 0 1 0 0; 1 1 1 0 0; 0 0 0 1 1; 1 0 0 0 1; 1 1 0 0 1; 1 1 1 0 1; 1 0 0 1 1; 1 1 1 1 1];
    checkprob( label_vector, instance_matrix, 10, predict_matrix, '-s 0 -t 2 -c 10 -b 1 -q', '-b 1 -q');
end


function checkprob( label_vector, instance_matrix, dup_num, predict_instances, train_param, predict_param)
    assert( size( label_vector, 1) == size( instance_matrix, 1), "Number of labels should be the same as number of instances");
    

    label_vector_duped = repmat( label_vector, dup_num, 1);
    instance_matrix_duped = repmat( instance_matrix, dup_num, 1);

    model = svmtrain( label_vector_duped, instance_matrix_duped, train_param);

    % disp( "model");
    % disp( model);

    printf("Predict results on training instances:\n");

    [ predict_label, accuracy, prob_estimates ] = svmpredict(
        label_vector, instance_matrix, model, predict_param);

    printLabelProb( label_vector, predict_label, prob_estimates, instance_matrix);
    printf("Accuracy: %d\n", accuracy(1));
    printf("Mean squared error: %f\n", accuracy(2));




    if !isempty( predict_instances)
        printf("Predict results on instances to be predicted:\n");
        label_vector = zeros( rows( predict_instances), 1);
        [ predict_label, accuracy, prob_estimates ] = svmpredict(
            label_vector, predict_instances, model, predict_param);

        printPredictLabelProb( predict_label, prob_estimates, predict_instances);
    end
    
end


function printLabelProb( label, predict_label, prob_estimates, instance_matrix)
    % print labels and probabilities
    assert( size( label, 1) == size( predict_label, 1));
    assert( size( predict_label, 1) == size( prob_estimates, 1));
    printf("%7s%9s%13s    %s\n", "Label", "Predict", "Probability", "Features");

    for eachRow = 1:size( predict_label, 1)
        printf("%7d%9.1f%13.6f    ", label( eachRow), predict_label( eachRow), max( prob_estimates( eachRow, :)));

        for eachInst = instance_matrix( eachRow, :)
            printf("%d ", eachInst);
        end
        printf("\n");
    end
end


function printPredictLabelProb( predict_label, prob_estimates, instance_matrix)
    % print labels and probabilities
    assert( size( predict_label, 1) == size( prob_estimates, 1));
    printf("%9s%13s    %s\n", "Predict", "Probability", "Features");

    for eachRow = 1:size( predict_label, 1)
        printf("%9d%13.6f    ", predict_label( eachRow), max(prob_estimates( eachRow, :)));

        for eachInst = instance_matrix( eachRow, :)
            printf("%d ", eachInst);
        end

        printf("\n");
    end
end
