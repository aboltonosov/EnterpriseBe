﻿
#Область СлужебныйПрограммныйИнтерфейс

// Чтение и запись записей периодических регистров сведений, подчиненных ведущему объекту 
// для редактирования регистров сведений в форме.
//
// Параметры:
//	Форма - управляемая форма
//	ИмяРегистра - имя редактируемого регистра.
//	ВедущийОбъект - ссылка на ведущий объект.
//
//	Требования:
//		Редактирование выполняется для регистров, где единственное измерение 
//		имеет тип "ведущего" объекта.
//		Форма должна содержать реквизиты
//			<ИмяРегистра> 				типа Менеджер записи
//			<ИмяРегистра>Прежняя 		типа Менеджер записи
//			<ИмяРегистра>НоваяЗапись 	типа булево
// см. также 
//		ИнициализироватьЗаписьДляРедактированияВФорме
//		ЗаписатьЗаписьПослеРедактированияВФорме.
Процедура ПрочитатьЗаписьДляРедактированияВФорме(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	ИмяИзмерения = Метаданные.РегистрыСведений[ИмяРегистра].Измерения[0].Имя;
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить(ИмяИзмерения, ВедущийОбъект);
	
	ПрочитатьЗаписьДляРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	
КонецПроцедуры

// Чтение и запись записей периодических регистров сведений, подчиненных ведущему объекту 
// для редактирования регистров сведений в форме.
//
// Параметры:
//	Форма - управляемая форма
//	ИмяРегистра - имя редактируемого регистра.
//	СтруктураВедущихОбъектов - структура ссылок на ведущие объекты.
//
//	Требования:
//		Редактирование выполняется для регистров, где единственное измерение 
//		имеет тип "ведущего" объекта.
//		Форма должна содержать реквизиты
//			<ИмяРегистра> 				типа Менеджер записи
//			<ИмяРегистра>Прежняя 		типа Менеджер записи
//			<ИмяРегистра>НоваяЗапись 	типа булево.
//
Процедура ПрочитатьЗаписьДляРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	МенеджерЗаписи = МенеджерПоследнейЗаписи(ИмяРегистра, СтруктураВедущихОбъектов);
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	
	// Имя реквизита формы совпадает с именем регистра.
	Форма.ЗначениеВРеквизитФормы(МенеджерЗаписи, ИмяРегистра);
	
	ЗаписьКакСтруктура = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(МенеджерЗаписи, МетаданныеРегистра);
	Форма[ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(ЗаписьКакСтруктура);
	
	Форма[ИмяРегистра + "НоваяЗапись"] = Ложь;
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВводаПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	
КонецПроцедуры

Функция МенеджерПоследнейЗаписи(ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	МенеджерЗаписи = МенеджерЗаписи(ИмяРегистра);
	
	Для каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
		ИмяИзмерения = МетаданныеРегистра.Измерения[ВедущийОбъект.Ключ].Имя;
		МенеджерЗаписи[ИмяИзмерения] = ВедущийОбъект.Значение;
	КонецЦикла;
	
	РегистрПериодический = МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;
	
	// Ищем последнюю запись
	Запрос = Новый Запрос;
	
	ПоляЗапроса = "";
	Если РегистрПериодический Тогда
		ПоляЗапроса = 
			"
			|	РегистрСведений.Период";
	КонецЕсли;
	Для каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		ПоляЗапроса = ПоляЗапроса + ?(ЗначениеЗаполнено(ПоляЗапроса), ",", "") +
			"
			|	РегистрСведений." + Измерение.Имя;
	КонецЦикла;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1" +
	ПоляЗапроса +
	"
	|ИЗ
	|	РегистрСведений." + ИмяРегистра + " КАК РегистрСведений";
	
	ПервоеПоле = Истина;
	Для каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
		Если ПервоеПоле Тогда
			Запрос.Текст = Запрос.Текст + "
				|ГДЕ";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|	" + ?(ПервоеПоле, "", "И ") + "РегистрСведений." + ВедущийОбъект.Ключ + " = &" + ВедущийОбъект.Ключ;
		Если ПервоеПоле Тогда
			ПервоеПоле = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если РегистрПериодический Тогда
		Запрос.Текст = 	Запрос.Текст +
		"
		|УПОРЯДОЧИТЬ ПО
		|	РегистрСведений.Период УБЫВ";
	КонецЕсли;
	
	Для каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
		Запрос.УстановитьПараметр(ВедущийОбъект.Ключ, ВедущийОбъект.Значение);
	КонецЦикла;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Прочитать();
	КонецЕсли;
	
	Возврат МенеджерЗаписи;
КонецФункции

// Запись записей периодических регистров сведений, подчиненных ведущему объекту 
// см. ПрочитатьЗаписьДляРедактированияВФорме.
// В параметре ДополнительныеСвойства передается структура, содержащая дополнительные свойства,
// которые необходимо установить при записи набора записей.
//
Функция ЗаписатьЗаписьПослеРедактированияВФорме(Форма, ИмяРегистра, ВедущийОбъект, ИменаКолонокИсключаемыхИзСравнения = "", ДополнительныеСвойства = Неопределено) Экспорт
	
	ИмяИзмерения = Метаданные.РегистрыСведений[ИмяРегистра].Измерения[0].Имя;
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить(ИмяИзмерения, ВедущийОбъект);
	
	Если Форма[ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
		Возврат ЗаписатьНаборЗаписейПослеРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов, ИменаКолонокИсключаемыхИзСравнения, ДополнительныеСвойства);
	КонецЕсли;
	
	Возврат ЗаписатьЗаписьПослеРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов, ИменаКолонокИсключаемыхИзСравнения, ДополнительныеСвойства);
	
КонецФункции

// Запись записей периодических регистров сведений, подчиненных ведущим объектам
// см. ПрочитатьЗаписьДляРедактированияВФормеПоСтруктуре.
// В параметре ДополнительныеСвойства передается структура, содержащая дополнительные свойства,
// которые необходимо установить при записи набора записей.
//
Функция ЗаписатьЗаписьПослеРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов, ИменаКолонокИсключаемыхИзСравнения = "", ДополнительныеСвойства = Неопределено) Экспорт
	
	Если Форма[ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
		Возврат ЗаписатьНаборЗаписейПослеРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов, ИменаКолонокИсключаемыхИзСравнения, ДополнительныеСвойства);
	КонецЕсли;
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	РегистрПериодический = МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;
	
	Если РегистрПериодический Тогда
		ИзменилисьДанные = Форма[ИмяРегистра].Период <> Форма[ИмяРегистра + "Прежняя"].Период;
	Иначе
		ИзменилисьДанные = Ложь;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ 
			(ВедущийОбъект.Значение <> Форма[ИмяРегистра + "Прежняя"][ВедущийОбъект.Ключ]
			И ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"][ВедущийОбъект.Ключ]));
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Измерения Цикл
			Если СтруктураВедущихОбъектов.Свойство(Поле.Имя) Тогда
				Продолжить;
			КонецЕсли; 
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Ресурсы Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Реквизиты Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	
	Если ИзменилисьДанные Тогда
		
		Для Каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
			Форма[ИмяРегистра][ВедущийОбъект.Ключ] = ВедущийОбъект.Значение;
		КонецЦикла;
		
		Если РегистрПериодический Тогда
			// Если нужно исправить старую запись, то сначала удалим ее.
			
			// 4D:ERP для Беларуси, Юлия, 11.01.2018 9:35:15 
			// Не записывается размер внесенного вручную годового вычета для вида дохода, № 17031
			// {
			// Действие не требуется.
			// }
			// 4D
			
			СохранитьЗаписьНабора(Форма[ИмяРегистра], ИмяРегистра, СтруктураВедущихОбъектов, ДополнительныеСвойства);
		Иначе
			Набор = НаборЗаписейРегистраСведений(ИмяРегистра, Неопределено, СтруктураВедущихОбъектов, ДополнительныеСвойства);
			
			НоваяЗапись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Форма[ИмяРегистра]);
			
			Набор.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИзменилисьДанные;
	
КонецФункции

// Инициализирует данные формы для обеспечения редактирования в ней записи 
// регистра сведений, подчиненного ведущему объекту.
//
// Параметры:
//	Форма - управляемая форма
//	ИмяРегистра - имя редактируемого регистра
// см. также 
//		ПрочитатьЗаписьДляРедактированияВФорме
//		ЗаписатьЗаписьПослеРедактированияВФорме.
//
Процедура ИнициализироватьЗаписьДляРедактированияВФорме(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	ИмяИзмерения = Метаданные.РегистрыСведений[ИмяРегистра].Измерения[0].Имя;
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить(ИмяИзмерения, ВедущийОбъект);
	
	ИнициализироватьЗаписьДляРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	
КонецПроцедуры

// Инициализирует данные формы для обеспечения редактирования в ней записи 
// регистра сведений, подчиненного ведущему объекту.
//
// Параметры:
//	Форма - управляемая форма
//	ИмяРегистра - имя редактируемого регистра.
//	СтруктураВедущихОбъектов - структура ссылок на ведущий объект.
//
Процедура ИнициализироватьЗаписьДляРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	МенеджерЗаписи = МенеджерЗаписи(ИмяРегистра);

	Для каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
		МенеджерЗаписи[ВедущийОбъект.Ключ] = ВедущийОбъект.Значение;
	КонецЦикла;
	Форма.ЗначениеВРеквизитФормы(МенеджерЗаписи, ИмяРегистра);
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	ЗаписьКакСтруктура = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(МенеджерЗаписи, МетаданныеРегистра);
	Форма[ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(ЗаписьКакСтруктура);
	
	Форма[ИмяРегистра + "НоваяЗапись"] = Ложь;
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВводаПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	
КонецПроцедуры

Процедура ПроверитьЗаписьВФорме(Форма, ИмяРегистра, ВедущийОбъект, Отказ) Экспорт
	
	ИмяИзмерения = Метаданные.РегистрыСведений[ИмяРегистра].Измерения[0].Имя;
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить(ИмяИзмерения, ВедущийОбъект);
	
	ПроверитьЗаписьВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов, Отказ);
	
КонецПроцедуры

Процедура ПроверитьЗаписьВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов, Отказ) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	Синоним = МетаданныеРегистра.Синоним;
	
	Если ЗначениеЗаполнено(МетаданныеРегистра.ПредставлениеЗаписи) Тогда
		Синоним = МетаданныеРегистра.ПредставлениеЗаписи;
	КонецЕсли;

	Если МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		ИзменилисьДанные = Форма[ИмяРегистра].Период <> Форма[ИмяРегистра + "Прежняя"].Период;
	Иначе
		ИзменилисьДанные = Ложь;
	КонецЕсли;
	
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ 
			(ВедущийОбъект.Значение <> Форма[ИмяРегистра + "Прежняя"][ВедущийОбъект.Ключ]
			И ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"][ВедущийОбъект.Ключ]));
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Ресурсы Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Реквизиты Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	
	Если ИзменилисьДанные Тогда
		МенеджерЗаписи = Форма.РеквизитФормыВЗначение(ИмяРегистра);
		
		Для Каждого СтандартныйРеквизит Из МетаданныеРегистра.СтандартныеРеквизиты Цикл
			
			Если СтандартныйРеквизит.Имя = "Период" Тогда
				Если ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"].Период) Тогда
					Если Форма.Элементы.Найти(ИмяРегистра + "ПериодСтрокой") <> Неопределено Тогда
						ПутьКРеквизитуФормы = ИмяРегистра + "ПериодСтрокой";
					Иначе
						ПутьКРеквизитуФормы = "";
					КонецЕсли;
					ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, СтандартныйРеквизит, Синоним, Отказ, ПутьКРеквизитуФормы);
				Иначе
					Если Не РедактированиеПериодическихСведенийКлиентСервер.ЗаполненыЗначенияПоУмолчаниюПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Тогда
						ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, СтандартныйРеквизит, Синоним, Отказ);
					КонецЕсли;
				КонецЕсли;
			Иначе
				ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, СтандартныйРеквизит, Синоним, Отказ);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
			Если Не СтруктураВедущихОбъектов.Свойство(Измерение.Имя) Тогда
				ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, Измерение, Синоним, Отказ);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
			ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, Ресурс, Синоним, Отказ);
		КонецЦикла;
		
		Для Каждого Реквизит Из МетаданныеРегистра.Реквизиты Цикл
			ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, Реквизит, Синоним, Отказ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МенеджерЗаписи(ИмяРегистра)
	
	МенеджерЗаписи = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
	Возврат МенеджерЗаписи;
	
КонецФункции

Процедура ПрочитатьНаборЗаписей(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	ИмяИзмерения = Метаданные.РегистрыСведений[ИмяРегистра].Измерения[0].Имя;
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить(ИмяИзмерения, ВедущийОбъект);
	
	ПрочитатьНаборЗаписейПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	
КонецПроцедуры

Процедура ПрочитатьНаборЗаписейПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	Для каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
		НаборЗаписей.Отбор[ВедущийОбъект.Ключ].Установить(ВедущийОбъект.Значение);
	КонецЦикла;
	НаборЗаписей.Прочитать();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
		Форма[ИмяРегистра + "НаборЗаписей"].Отбор[ВедущийОбъект.Ключ].Значение = ВедущийОбъект.Значение;
		Форма[ИмяРегистра + "НаборЗаписей"].Отбор[ВедущийОбъект.Ключ].Использование = Истина;
	КонецЦикла;
	
	Форма[ИмяРегистра + "НаборЗаписей"].Загрузить(НаборЗаписей.Выгрузить());
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Форма[ИмяРегистра + "НаборЗаписейПрочитан"] = Истина;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, ОписаниеПоля, Синоним, Отказ, ПутьКРеквизитуФормы = "")
	
	Если ОписаниеПоля.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку И Не ЗначениеЗаполнено(МенеджерЗаписи[ОписаниеПоля.Имя]) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1: не заполнено поле ""%2"".'"), Синоним, ?(ЗначениеЗаполнено(ОписаниеПоля.Синоним), ОписаниеПоля.Синоним, ОписаниеПоля.Имя));
		Если ПустаяСтрока(ПутьКРеквизитуФормы) Тогда
			ПутьКРеквизитуФормы = ИмяРегистра + "." + ОписаниеПоля.Имя;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,	ПутьКРеквизитуФормы, , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаписатьНаборЗаписейПослеРедактированияВФормеПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов, ИменаКолонокИсключаемыхИзСравнения, ДополнительныеСвойства)
	
	ИзменилисьДанные = Ложь;
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьНаборЗаписейИсторииПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	
	// Подготовим к сравнению набор исходных сведений.
	Набор = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	МенеджерЗаписи = МенеджерЗаписи(ИмяРегистра);
	Для Каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
		Набор.Отбор[ВедущийОбъект.Ключ].Установить(ВедущийОбъект.Значение);
		МенеджерЗаписи[ВедущийОбъект.Ключ] = ВедущийОбъект.Значение;
	КонецЦикла;
	Набор.Прочитать();
	ТаблицаИсходногоНабора = Набор.Выгрузить();
	
	// Подготовим к сравнению набор, хранящийся в реквизите формы.
	ТаблицаНовогоНабора = Форма[ИмяРегистра + "НаборЗаписей"].Выгрузить();
	ТаблицаНовогоНабора.Колонки.Удалить("ИсходныйНомерСтроки");
	
	Если ЗначениеЗаполнено(ИменаКолонокИсключаемыхИзСравнения) Тогда
		
		ИсключаемыеКолонки = СтрРазделить(ИменаКолонокИсключаемыхИзСравнения, ",", Ложь);
		Для каждого ИмяИсключаемойКолонки Из ИсключаемыеКолонки Цикл
			ТаблицаИсходногоНабора.Колонки.Удалить(ИмяИсключаемойКолонки);
			ТаблицаНовогоНабора.Колонки.Удалить(ИмяИсключаемойКолонки);
		КонецЦикла;
		
	КонецЕсли;
	
	// Проверим необходимость записи нового набора.
	Если НЕ ОбщегоНазначения.КоллекцииИдентичны(ТаблицаИсходногоНабора, ТаблицаНовогоНабора) Тогда
		
		ИзменилисьДанные = Истина;
		
		Если Форма[ИмяРегистра + "НаборЗаписей"].Свойство("Период") Тогда
			
			ТаблицаНовогоНабора.Сортировать("Период Убыв");
			
			Для Каждого СтрокаТаблицаНовогоНабора Из ТаблицаНовогоНабора Цикл
				
				ДополнительныеСвойстваДляЗаписи = ДополнительныеСвойства;
				
				СохранитьСтроку = Истина;
				СтрокаТаблицаИсходногоНабора = ТаблицаИсходногоНабора.Найти(СтрокаТаблицаНовогоНабора.Период, "Период");
				Если СтрокаТаблицаИсходногоНабора <> Неопределено Тогда
					Если ОбщегоНазначения.КоллекцииИдентичны(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицаНовогоНабора), ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицаИсходногоНабора)) Тогда
						СохранитьСтроку = Ложь;
					КонецЕсли;
					// Удалим строку из таблицы исходного набора.
					ТаблицаИсходногоНабора.Удалить(СтрокаТаблицаИсходногоНабора);
				Иначе
					Если ОбщегоНазначения.КоллекцииИдентичны(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицаНовогоНабора), ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(МенеджерЗаписи, Метаданные.РегистрыСведений[ИмяРегистра])) Тогда
						Если ДополнительныеСвойства = Неопределено Тогда
							ДополнительныеСвойстваДляЗаписи = Новый Структура;
						Иначе
							ДополнительныеСвойстваДляЗаписи = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДополнительныеСвойства);
						КонецЕсли;
						ДополнительныеСвойстваДляЗаписи.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
					КонецЕсли;
				КонецЕсли; 
				
				Если СохранитьСтроку Тогда
					СохранитьЗаписьНабора(СтрокаТаблицаНовогоНабора, ИмяРегистра, СтруктураВедущихОбъектов, ДополнительныеСвойстваДляЗаписи)
				КонецЕсли; 
				
			КонецЦикла;
			
			Для каждого СтрокаТаблицаИсходногоНабора Из ТаблицаИсходногоНабора Цикл
				УдалитьЗаписьНабора(СтрокаТаблицаИсходногоНабора.Период, ИмяРегистра, СтруктураВедущихОбъектов, ДополнительныеСвойства);
			КонецЦикла;
		Иначе
			Набор.Загрузить(ТаблицаНовогоНабора);
			Набор.Записать();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИзменилисьДанные;
	
КонецФункции

Функция НаборЗаписейРегистраСведений(ИмяРегистра, Период, СтруктураВедущихОбъектов, ДополнительныеСвойства)
	
	Набор = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	Если МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		Набор.Отбор.Период.Установить(Период);
	КонецЕсли;
	Для Каждого ВедущийОбъект Из СтруктураВедущихОбъектов Цикл
		Набор.Отбор[ВедущийОбъект.Ключ].Установить(ВедущийОбъект.Значение);
	КонецЦикла;
	
	Если ДополнительныеСвойства <> Неопределено Тогда
		Для каждого ДополнительноеСвойство Из ДополнительныеСвойства Цикл
			Набор.ДополнительныеСвойства.Вставить(ДополнительноеСвойство.Ключ, ДополнительноеСвойство.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Набор;
	
КонецФункции

Процедура СохранитьЗаписьНабора(Запись, ИмяРегистра, СтруктураВедущихОбъектов, ДополнительныеСвойства)
	
	Набор = НаборЗаписейРегистраСведений(ИмяРегистра, Запись.Период, СтруктураВедущихОбъектов, ДополнительныеСвойства);
	
	НоваяЗапись = Набор.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, Запись);
	
	Набор.Записать();
	
КонецПроцедуры

Процедура УдалитьЗаписьНабора(Период, ИмяРегистра, СтруктураВедущихОбъектов, ДополнительныеСвойства)
	
	Набор = НаборЗаписейРегистраСведений(ИмяРегистра, Период, СтруктураВедущихОбъектов, ДополнительныеСвойства);
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти
