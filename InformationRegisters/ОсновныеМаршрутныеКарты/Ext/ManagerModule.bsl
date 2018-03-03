﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОсновнаяМаршрутнаяКарта(Номенклатура, Характеристика, Подразделение) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОсновныеМаршрутныеКарты.МаршрутнаяКарта
	|ИЗ
	|	РегистрСведений.ОсновныеМаршрутныеКарты КАК ОсновныеМаршрутныеКарты
	|ГДЕ
	|	ОсновныеМаршрутныеКарты.Номенклатура = &Номенклатура
	|	И ОсновныеМаршрутныеКарты.Характеристика = &Характеристика
	|	И ОсновныеМаршрутныеКарты.Подразделение = &Подразделение");
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Результат = Выборка.МаршрутнаяКарта;
		
	Иначе
		
		Результат = Неопределено;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли