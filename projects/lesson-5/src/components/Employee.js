import React, { Component } from 'react'
import {Card, Col, Row, Layout, Alert, message, Button } from 'antd';

import Common from './Common';

class Employee extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    this.checkEmployee();
  }

  checkEmployee = () => {
    const { payroll, employee, web3} = this.props; 
    payroll.employees.call(employee, {
      from: employee,
      gas:1000000
    }).then((result) => {
      console.log(result)
      this.setState({
        salary: web3.fromWei(result[1].toNumber()),
        lastPaidDate: new Date(result[2].toNumber() * 1000)
      });
    });
  }

  getPaid = () => {
    const { payroll, employee } = this.props; 
    payroll.getPaid({
      from: employee,
      gas:1000000
    }).then((result) => {
      alert('You have been paid');
    });
  }

  renderContent() {
    const { salary, lastPaidDate, balance } = this.state;

    if (!salary || salary === '0') {
      return <Alert message="you are not our employee" type="error" showIcon />;
    }

    return (
      <div>
          <Row gutter={16}>
            <Col span={8}>
              <Card title="salary">{salary} Ether </Card>
            </Col>
            <Col span={8}>
              <Card title="lastPaidDate">{lastPaidDate}</Card>
            </Col>
            <Col span={8}>
              <Card title="balance">{balance} Ether </Card>
            </Col>
          </Row>

          <Button
            type="primary"
            icon="bank"
            onClick={this.getPaid}
          >
          getPaid
          </Button>
      </div>
    );
  }

  render() {
    const { account, payroll, web3 } = this.props;

    return (
      <Layout style={{ padding: '0 24px', background: '#fff' }}>
        <Common account={account} payroll={payroll} web3={web3} />
        <h2>Personal info</h2>
        {this.renderContent()}
      </Layout>
    );
  }
}

export default Employee
