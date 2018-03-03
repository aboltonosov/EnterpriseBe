﻿
&НаСервере
Процедура ВыполнитьАрхивациюЧековНаСервере(КассоваяСмена)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КассоваяСмена.Ссылка КАК КассоваяСмена
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.Проведен
	|	И КассоваяСмена.Ссылка В (&КассоваяСмена)
	|	И КассоваяСмена.СтатусКассовойСмены = &СтатусКассовойСмены
	|	И КассоваяСмена.КассаККМ.ТипКассы = &ТипКассыФискальныйРегистратор";
	
	Запрос.УстановитьПараметр("КассоваяСмена", КассоваяСмена);
	Запрос.УстановитьПараметр("СтатусКассовойСмены", Перечисления.СтатусыКассовойСмены.Закрыта);
	Запрос.УстановитьПараметр("ТипКассыФискальныйРегистратор", Перечисления.ТипыКассККМ.ФискальныйРегистратор);
	
	Выборка = Запрос.Выполнить();
	ОбрабатываемыеКассовыеСмены = Выборка.Выгрузить().ВыгрузитьКолонку("КассоваяСмена");
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("КассоваяСмена", ОбрабатываемыеКассовыеСмены);
	ПараметрыЗадания.Вставить("ОбработкаВыполнена", Ложь);
	
	РозничныеПродажи.ВыполнитьАрхивациюЧековККМ(ПараметрыЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОчиститьСообщения();
	
	ВыполнитьАрхивациюЧековНаСервере(ПараметрКоманды);
	
	Оповестить("Запись_ОтчетОРозничныхПродажах", Новый Структура, ПараметрКоманды);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Архивация чеков ККМ выполнена'"));
	
КонецПроцедуры
