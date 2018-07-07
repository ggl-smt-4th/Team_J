import React, { Component } from 'react'
import { Card, Col, Row } from 'antd';

class Common extends Component {
  constructor(props) {
    super(props);

    this.state = {};
  }

  componentDidMount() {
    const { payroll, web3, account } = this.props;
    const updateInfo = (error, result) => {
      if (!error) {
        this.checkInfo();
      }
    }
    this.newFund = payroll.NewFund(updateInfo);
    this.getPaid = payroll.GetPaid(updateInfo);
    this.newEmployee = payroll.NewEmployee(updateInfo);
    this.updateEmployee = payroll.UpdateEmployee(updateInfo);
    this.removeEmployee = payroll.RemoveEmployee(updateInfo);
    this.checkInfo();
  }

  componentWillUnmount() {
    this.newFund.stopWatching();
    this.getPaid.stopWatching();
    this.newEmployee = new type(arguments);.stopWatching();
    this.updateEmployee.stopWatching();
    this.removeEmployee.stopWatching();
  }

  render() {
    const { runway, balance, employeeCount } = this.state;
    return (
      <div>
        <h2>通用信息</h2>
        <Row gutter={16}>
        <Col span={8}>
          <Card title="合约金额">{balance} Ether</Card>
        </Col>
        <Col span={8}>
          <Card title="员工人数">{employeeCount}</Card>
        </Col>
        <Col span={8}>
        <Card title="可支付次数">{runway}</Card>
        </Col>
        </Row>
      </div>
    );
  }
}

export default Common