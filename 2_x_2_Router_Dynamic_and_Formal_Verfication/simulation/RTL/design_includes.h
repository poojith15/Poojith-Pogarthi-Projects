typedef struct packed { logic head; logic tail; logic valid; logic [31:0] data; logic output_port_num; logic txn_id;} pkt_flit_t;
