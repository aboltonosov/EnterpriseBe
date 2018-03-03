﻿
// 4D:ERP для Беларуси, Яна, 22.08.2017 9:28:12 
// Регистр сведений "Бюджет прожиточного минимума", №15781
// {
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение сведений 
// о минимальном размере оплаты труда в РФ.
//
Процедура НачальноеЗаполнение() Экспорт
	
	Если ОбменДаннымиПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		Возврат;
	КонецЕсли;
	
	КлассификаторXML = РегистрыСведений.ВеличинаПрожиточногоМинимума.ПолучитьМакет("БюджетПрожиточногоМинимума").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	НаборЗаписей = РегистрыСведений.ВеличинаПрожиточногоМинимума.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		СтрокаНабора = НаборЗаписей.Добавить();
		СтрокаНабора.Период 				= Дата(СтрокаКлассификатора.Date);
		СтрокаНабора.Размер					= Число(СтрокаКлассификатора.Rate);
		СтрокаНабора.ПрожиточныйМинимум  = Справочники.ПрожиточныеМинимумы.ПрожиточныйМинимумРБ;
	КонецЦикла;
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Функция предназначена для получения данных о бюджете прожиточного минимума.
// Данные включают в себя сам размер и дату, с которой он действует.
//
// Параметры:
//	ДатаАктуальности - дата, на которую нужно получить размер БПМ (необязательный), 
//						если не заполнен, возвращается последнее действующее значение.
//
// Возвращаемое значение - структура, полями которой являются Размер и Период.
//
Функция ДанныеБюбджетаПрожиточногоМинимума(ДатаАктуальности = Неопределено) Экспорт
	
	ДанныеБПМ = Новый Структура("Размер,ПрожиточныйМинимум,Период");
	
	СрезПоследних = РегистрыСведений.ВеличинаПрожиточногоМинимума.СрезПоследних(ДатаАктуальности);
	Если СрезПоследних.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Сведения о бюджете прожиточного минимума не заполнены'");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ДанныеБПМ, СрезПоследних[0]);
	
	Возврат ДанныеБПМ;
	
КонецФункции

// Проверяет заполненность данных о бюджете прожиточного минимума.
//
// Возвращаемое значение - булево, Истина - если есть хотя бы одно значение.
//
Функция БюбджетПрожиточногоМинимумаЗаполнен() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Поле1
	|ИЗ
	|	РегистрСведений.ВеличинаПрожиточногоМинимума КАК БюджетПрожиточногоМинимума");
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура ЗаполнитьБПМ_РБ() Экспорт 
	
	НаборЗаписей = РегистрыСведений.ВеличинаПрожиточногоМинимума.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	ДатаСведений = '20161101';	
	НаборЗаписей.Отбор.Период.Установить(ДатаСведений);	
	ДобавитьЗаписьБМП(НаборЗаписей, ДатаСведений, 174.52);		
	НаборЗаписей.Записать();
	НаборЗаписей.Очистить();
	
	НаборЗаписей = РегистрыСведений.ВеличинаПрожиточногоМинимума.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	ДатаСведений = '20170201';	
	НаборЗаписей.Отбор.Период.Установить(ДатаСведений);	
	ДобавитьЗаписьБМП(НаборЗаписей, ДатаСведений, 180.1);		
	НаборЗаписей.Записать();
	НаборЗаписей.Очистить();
				
КонецПроцедуры 

Процедура ДобавитьЗаписьБМП(НаборЗаписей, ДатаСведений, Размер) 
	НоваяЗапись = НаборЗаписей.Добавить();

	НоваяЗапись.Период         = ДатаСведений;
	НоваяЗапись.Размер         = Размер;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
// }
// 4D
