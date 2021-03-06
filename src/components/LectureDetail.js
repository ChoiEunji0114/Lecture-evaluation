import React, { Component } from 'react';
import { connect } from 'react-redux';

import './LectureDetail.scss';
import { Table } from 'react-bootstrap'
import DetailLec from '../components/LectureDetail1'

class LectureDetail extends Component {
  render() {
    const { listItems, lectureName, lecturePro, courseId } = this.props
    console.log(listItems)
    if (!this.props.listItems) {
      return <div> 강의를 선택하세요  </div>;
    }
    return (
      <div className='lectureDetail__list col'>
        <br></br> 
        <DetailLec
          items={listItems}
          lectureName={lectureName}
          lecturePro={lecturePro}
          courseId={courseId}
        />
      </div>
    );
  }
}

export default LectureDetail;